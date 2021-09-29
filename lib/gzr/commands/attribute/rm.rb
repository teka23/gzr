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
      class Rm < Gzr::Command
        include Gzr::Attribute
        def initialize(attr,options)
          super()
          @attr = attr
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning(@options) if @options[:debug]
          with_session do
            id = @attr if /^\d+$/.match @attr
            attr = nil
            if id
              attr = query_user_attribute(id)
            else
              attr = get_attribute_by_name(@attr)
            end

            raise(Gzr::CLI::Error, "Attribute #{@attr} does not exist") unless attr
            raise(Gzr::CLI::Error, "Attribute #{attr[:name]} is a system built-in and cannot be deleted ") if attr[:is_system]
            raise(Gzr::CLI::Error, "Attribute #{attr[:name]} is marked permanent and cannot be deleted ") if attr[:is_permanent]

            delete_user_attribute(attr.id)

            output.puts "Deleted attribute #{attr.name} #{attr.id}" unless @options[:plain] 
            output.puts attr.id if @options[:plain] 
          end
        end
      end
    end
  end
end
