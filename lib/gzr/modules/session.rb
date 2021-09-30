# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# frozen_string_literal: true

require 'json'
require 'pastel'
require 'tty-reader'

require_relative '../../gzr'

module Gzr
  module Session

    def pastel
      @pastel ||= Pastel.new
    end

    def say_ok(data, output: $stdout)
      output.puts pastel.green data
    end

    def say_warning(data, output: $stdout)
      output.puts pastel.yellow data
    end

    def say_error(data, output: $stdout)
      output.puts pastel.red data
    end

    def v3_1_available?
      @v3_1_available ||= false
    end

    def build_connection_hash(api_version='3.0')
      conn_hash = Hash.new
      conn_hash[:api_endpoint] = "http#{@options[:ssl] ? "s" : ""}://#{@options[:host]}:#{@options[:port]}/api/#{api_version}"
      if @options[:http_proxy]
        conn_hash[:connection_options] ||= {}
        conn_hash[:connection_options][:proxy] = {
          :uri => @options[:http_proxy]
        }
      end
      if @options[:ssl]
        conn_hash[:connection_options] ||= {}
        if @options[:verify_ssl] then
          conn_hash[:connection_options][:ssl] = {
            :verify => true,
            :verify_mode => (OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
          }
        else
          conn_hash[:connection_options][:ssl] = {
            :verify => false
          }
        end
      end
      if @options[:timeout]
        conn_hash[:connection_options] ||= {}
        conn_hash[:connection_options][:request] = {
          :timeout => @options[:timeout]
        }
      end
      conn_hash[:user_agent] = "Gazer #{Gzr::VERSION}"
      if @options[:client_id] then
        conn_hash[:client_id] = @options[:client_id]
        if @options[:client_secret] then
          conn_hash[:client_secret] = @options[:client_secret]
        else
          reader = TTY::Reader.new
          @secret ||= reader.read_line("Enter your client_secret:", echo: false)
          conn_hash[:client_secret] = @secret
        end
      else
        conn_hash[:netrc] = true
        conn_hash[:netrc_file] = "~/.netrc"
      end
      conn_hash
    end

    def login(api_version)
      @secret = nil
      versions = nil
      current_version = nil
      begin
        conn_hash = build_connection_hash

        sawyer_options = {
          :links_parser => Sawyer::LinkParsers::Simple.new,
          :serializer  => LookerSDK::Client::Serializer.new(JSON),
          :faraday => Faraday.new(conn_hash[:connection_options])
        }

        endpoint = conn_hash[:api_endpoint]
        endpoint_uri = URI.parse(endpoint)
        root = endpoint.slice(0..-endpoint_uri.path.length)

        agent = Sawyer::Agent.new(root, sawyer_options) do |http|
          http.headers[:accept] = 'application/json'
          http.headers[:user_agent] = conn_hash[:user_agent]
        end

        begin
          versions_response = agent.call(:get,"/versions")
          versions = versions_response.data.supported_versions
          current_version = versions_response.data.current_version
        rescue Faraday::SSLError => e
          raise Gzr::CLI::Error, "SSL Certificate could not be verified\nDo you need the --no-verify-ssl option or the --no-ssl option?"
        rescue Faraday::ConnectionFailed => cf
          raise Gzr::CLI::Error, "Connection Failed.\nDid you specify the --no-ssl option for an ssl secured server?\nYou may need to use --port=443 in some cases as well."
        rescue LookerSDK::NotFound => nf
          say_warning "endpoint #{root}/versions was not found"
        end
        versions.each do |v|
          @v3_1_available = true if v.version == "3.1"
        end
      end

      say_warning "API 3.1 available? #{v3_1_available?}" if @options[:debug]

      raise Gzr::CLI::Error, "Operation requires API v3.1, but user specified a different version" if (api_version == "3.1") && @options[:api_version] && !("3.1" == @options[:api_version])
      raise Gzr::CLI::Error, "Operation requires API v3.1, which is not available from this host" if (api_version == "3.1") && !v3_1_available?

      conn_hash = build_connection_hash(@options[:api_version] || current_version.version)
      @secret = nil

      say_ok("connecting to #{conn_hash.map { |k,v| "#{k}=>#{(k == :client_secret) ? '*********' : v}" }}") if @options[:debug]

      begin
        @sdk = LookerSDK::Client.new(conn_hash) unless @sdk
        say_ok "check for connectivity: #{@sdk.alive?}" if @options[:debug]
        say_ok "verify authentication: #{@sdk.authenticated?}" if @options[:debug]
      rescue LookerSDK::Unauthorized => e
        say_error "Unauthorized - credentials are not valid"
        raise
      rescue LookerSDK::Error => e
        say_error "Unable to connect"
        say_error e.message
        say_error e.errors if e.respond_to?(:errors) && e.errors
        raise
      end
      raise Gzr::CLI::Error, "Invalid credentials" unless @sdk.authenticated?


      if @options[:su] then
        say_ok "su to user #{@options[:su]}" if @options[:debug]
        @access_token_stack.push(@sdk.access_token)
        begin
          @sdk.access_token = @sdk.login_user(@options[:su]).access_token
          say_warning "verify authentication: #{@sdk.authenticated?}" if @options[:debug]
        rescue LookerSDK::Error => e
          say_error "Unable to su to user #{@options[:su]}" 
          say_error e.message
          say_error e.errors if e.respond_to?(:errors) && e.errors
          raise
        end
      end
      @sdk
    end

    def logout_all
      pastel = Pastel.new(enabled: true)
      say_ok "logout" if @options[:debug]
      begin
        @sdk.logout
      rescue LookerSDK::Error => e
        say_error "Unable to logout"
        say_error e.message
        say_error e.errors if e.respond_to?(:errors) && e.errors
      end if @sdk
      loop do
        token = @access_token_stack.pop
        break unless token
        say_ok "logout the parent session" if @options[:debug]
        @sdk.access_token = token
        begin
          @sdk.logout
        rescue LookerSDK::Error => e
          say_error "Unable to logout"
          say_error e.message
          say_error e.errors if e.respond_to?(:errors) && e.errors
        end
      end
    end

    def with_session(api_version="3.0")
      return nil unless block_given?
      begin
        login(api_version) unless @sdk
        yield
      rescue LookerSDK::Error => e
        say_error e.errors if e.respond_to?(:errors) && e.errors
        e.backtrace.each { |b| say_error b } if @options[:debug]
        raise Gzr::CLI::Error, e.message
      ensure
        logout_all
      end
    end
  end
end
