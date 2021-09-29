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
      class Import < Gzr::Command
        include Gzr::Attribute
        include Gzr::FileHelper
        def initialize(file,options)
          super()
          @file = file
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning(@options) if @options[:debug]
          with_session do
            read_file(@file) do |source|
              attr = upsert_user_attribute(source, @options[:force], output: $stdout)
              output.puts "Imported attribute #{attr.name} #{attr.id}" unless @options[:plain] 
              output.puts attr.id if @options[:plain] 
            end
          end
        end
      end
    end
  end
end
