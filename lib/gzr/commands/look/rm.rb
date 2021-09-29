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
require_relative '../../modules/look'

module Gzr
  module Commands
    class Look
      class Rm < Gzr::Command
        include Gzr::Look
        def initialize(look_id, options)
          super()
          @look_id = look_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do
            if @options[:restore]
              update_look(@look_id, {:deleted=>false})
            elsif @options[:soft]
              update_look(@look_id, {:deleted=>true})
            else
              delete_look(@look_id)
            end
          end
        end
      end
    end
  end
end
