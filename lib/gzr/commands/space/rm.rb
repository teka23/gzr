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
require_relative '../../modules/space'

module Gzr
  module Commands
    class Space
      class Rm < Gzr::Command
        include Gzr::Space
        def initialize(space,options)
          super()
          @space = space
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          with_session do
            space = query_space(@space)

            begin
              puts "Space #{@space} not found"
              return nil
            end unless space
            children = query_space_children(@space)
            unless (space.looks.length == 0 && space.dashboards.length == 0 && children.length == 0) || @options[:force] then
              raise Gzr::CLI::Error, "Space '#{space.name}' is not empty. Space cannot be deleted unless --force is specified"
            end
            delete_space(@space)
          end
        end
      end
    end
  end
end
