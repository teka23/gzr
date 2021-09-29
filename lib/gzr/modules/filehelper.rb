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

require 'pathname'
require 'rubygems/package'

module Gzr
  module FileHelper
    def write_file(file_name=nil,base_dir=nil,path=nil,output=$stdout)
      f = nil
      if base_dir.respond_to?(:mkdir)&& (base_dir.respond_to?(:add_file) || base_dir.respond_to?(:get_output_stream)) then
        if path then
          @archived_paths ||= Array.new
          begin
            base_dir.mkdir(path.to_path, 0755) unless @archived_paths.include?(path.to_path)
          rescue Errno::EEXIST => e
            nil
          end
          @archived_paths << path.to_path
        end
        fn = Pathname.new(file_name.gsub('/',"\u{2215}"))
        fn = path + fn if path
        if base_dir.respond_to?(:add_file)
          base_dir.add_file(fn.to_path, 0644) do |tf|
            yield tf
          end
        elsif base_dir.respond_to?(:get_output_stream)
          base_dir.get_output_stream(fn.to_path, 0644) do |zf|
            yield zf
          end
        end
        return
      end

      base = Pathname.new(File.expand_path(base_dir)) if base_dir
      begin
        p = Pathname.new(path) if path
        p.descend do |path_part|
          test_dir = base + Pathname.new(path_part)
          Dir.mkdir(test_dir) unless (test_dir.exist? && test_dir.directory?)
        end if p
        file = Pathname.new(file_name.gsub('/',"\u{2215}").gsub(':','')) if file_name
        file = p + file if p
        file = base + file if base
        f = File.open(file, "wt") if file
      end if base

      return ( f || output ) unless block_given?
      begin
        yield ( f || output )
      ensure
        f.close if f
      end
      nil
    end

    def read_file(file_name)
      file = nil
      data_hash = nil
      begin
        file = (file_name.kind_of? StringIO) ? file_name : File.open(file_name)
        data_hash = JSON.parse(file.read,{:symbolize_names => true})
      ensure
        file.close if file
      end
      return (data_hash || {}) unless block_given?

      yield data_hash || {}
    end
  end
end
