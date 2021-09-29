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
require_relative '../../modules/group'
require_relative '../../modules/attribute'

module Gzr
  module Commands
    class Attribute
      class SetGroupValue < Gzr::Command
        include Gzr::Attribute
        include Gzr::Group
        def initialize(group,attr,value,options)
          super()
          @group = group
          @attr = attr
          @value = value
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning(@options) if @options[:debug]
          with_session("3.1") do

            group_id = @group if /^\d+$/.match @group
            group = nil
            if group_id
              group = query_group(group_id)
            else
              results = search_groups(@group)
              if results && results.length == 1
                group = results.first
              elsif results
                raise(Gzr::CLI::Error, "Pattern #{@group} matched more than one group")
              else
                raise(Gzr::CLI::Error, "Pattern #{@group} did not match any groups")
              end
            end

            attr_id = @attr if /^\d+$/.match @attr
            attr = nil
            if attr_id
              attr = query_user_attribute(attr_id)
            else
              attr = get_attribute_by_name(@attr)
            end
            raise(Gzr::CLI::Error, "Attribute #{@attr} does not exist") unless attr

            data = update_user_attribute_group_value(group.id,attr.id, @value)
            say_warning("Attribute #{attr.name} does not have a value set for group #{group.name}", output: output) unless data
            output.puts "Group attribute #{data.id} set to #{data.value}"
          end
        end
      end
    end
  end
end
