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
require_relative '../../modules/filehelper'

module Gzr
  module Commands
    class Attribute
      class Cat < Gzr::Command
        include Gzr::Attribute
        include Gzr::FileHelper
        def initialize(attr,options)
          super()
          @attr = attr
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning(@options) if @options[:debug]
          with_session do
            f = @options[:fields]
            id = @attr if /^\d+$/.match @attr
            attr = nil
            if id
              attr = query_user_attribute(id,f)
            else
              attr = get_attribute_by_name(@attr,f)
            end
            raise(Gzr::CLI::Error, "Attribute #{@attr} does not exist") unless attr
            write_file(@options[:dir] ? "Attribute_#{attr.id}_#{attr.name}.json" : nil, @options[:dir],nil, output) do |f|
              f.puts JSON.pretty_generate(attr.to_attrs)
            end
          end
        end
      end
    end
  end
end
