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

require_relative '../../command'
require_relative '../../modules/attribute'

module Gzr
  module Commands
    class Attribute
      class Create < Gzr::Command
        include Gzr::Attribute
        def initialize(name,label,options)
          super()
          @name = name
          @label = label || @name.split(/ |\_|\-/).map(&:capitalize).join(" ")
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning(@options) if @options[:debug]
          with_session do
            source = { :name=>@name, :label=>@label, :type=>@options[:type] }
            source[:'default_value'] = @options[:'default-value'] if @options[:'default-value']
            source[:'value_is_hidden'] = true if @options[:'is-hidden']
            source[:'user_can_view'] = true if @options[:'can-view']
            source[:'user_can_edit'] = true if @options[:'can-edit']
            source[:'hidden_value_domain_whitelist'] = @options[:'domain-whitelist'] if @options[:'is-hidden'] && @options[:'domain-whitelist']

            attr = upsert_user_attribute(source, @options[:force], output: $stdout)
            output.puts "Imported attribute #{attr.name} #{attr.id}" unless @options[:plain] 
            output.puts attr.id if @options[:plain] 
          end
        end
      end
    end
  end
end
