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
require_relative '../../modules/plan'
require_relative '../../modules/filehelper'

module Gzr
  module Commands
    class Look
      class Cat < Gzr::Command
        include Gzr::Look
        include Gzr::FileHelper
        include Gzr::Plan
        def initialize(look_id,options)
          super()
          @look_id = look_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do
            data = query_look(@look_id).to_attrs
            find_vis_config_reference(data) do |vis_config|
              find_color_palette_reference(vis_config) do |o,default_colors|
                rewrite_color_palette!(o,default_colors)
              end
            end

            data[:scheduled_plans] = query_scheduled_plans_for_look(@look_id,"all").to_attrs if @options[:plans]
            write_file(@options[:dir] ? "Look_#{data[:id]}_#{data[:title]}.json" : nil, @options[:dir],nil, output) do |f|
              f.puts JSON.pretty_generate(data)
            end
          end
        end
      end
    end
  end
end
