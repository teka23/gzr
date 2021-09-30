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
require_relative '../../command'
require_relative '../../modules/dashboard'
require_relative '../../modules/plan'
require_relative '../../modules/filehelper'

module Gzr
  module Commands
    class Dashboard
      class Cat < Gzr::Command
        include Gzr::Dashboard
        include Gzr::FileHelper
        include Gzr::Plan
        def initialize(dashboard_id,options)
          super()
          @dashboard_id = dashboard_id
          @options = options
        end

        def execute(*args, input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session("3.1") do
            data = query_dashboard(@dashboard_id).to_attrs
            data[:dashboard_elements].each_index do |i|
              element = data[:dashboard_elements][i]
              find_vis_config_reference(element) do |vis_config|
                find_color_palette_reference(vis_config) do |o,default_colors|
                  rewrite_color_palette!(o,default_colors)
                end
              end
              merge_result = merge_query(element[:merge_result_id])&.to_attrs if element[:merge_result_id]
              if merge_result
                merge_result[:source_queries].each_index do |j|
                  source_query = merge_result[:source_queries][j]
                  merge_result[:source_queries][j][:query] = query(source_query[:query_id]).to_attrs
                end
                find_vis_config_reference(merge_result) do |vis_config|
                  find_color_palette_reference(vis_config) do |o,default_colors|
                    rewrite_color_palette!(o,default_colors)
                  end
                end
                data[:dashboard_elements][i][:merge_result] = merge_result
              end
            end
            data[:scheduled_plans] = query_scheduled_plans_for_dashboard(@dashboard_id,"all").to_attrs if @options[:plans]

            replacements = {}
            if @options[:transform]

              max_row = 0
              data[:dashboard_layouts][0][:dashboard_layout_components].each_index do |i|
                component = data[:dashboard_layouts][0][:dashboard_layout_components][i]
                if component[:row] + component[:height] > max_row
                  max_row = component[:row] + component[:height] + 4
                end
              end

              read_file(@options[:transform]) do |transform|
                i = 0
                transform[:dashboard_elements].collect! do |e|
                  i += 1
                  # there is no significance to 9900, we just need to prevent ID collisions
                  e['id'] = 9900 + i
                  data[:dashboard_elements] << e

                  # when inserting an element into the top row, shift the other elements down according to the height of the inserted element
                  if e[:position] === 'top'
                    data[:dashboard_layouts][0][:dashboard_layout_components].each_index do |i|
                      component = data[:dashboard_layouts][0][:dashboard_layout_components][i]
                      component[:row] = component[:row] + e[:height]
                    end
                    row = '0'
                  elsif e[:position] === 'bottom'
                    row = max_row.to_s
                  end

                  column = '0'
                  width = e[:width].to_s
                  height = e[:height].to_s
                  data[:dashboard_layouts][0][:dashboard_layout_components] << JSON.parse('{"id":' + e['id'].to_s + ',"dashboard_layout_id":1,"dashboard_element_id":' + e['id'].to_s + ''',"row":' + row + ',"column":' + column + ',"width":' + width + ',"height":' + height + ',"deleted":false,"element_title_hidden":false,"vis_type":"' + e[:type].to_s + '","can":{"index":true,"show":true,"create":true,"update":true,"destroy":true}}')
                end

                transform[:replacements].collect! do |e|
                  replacements[e.keys.first.to_s] = e[e.keys[0]]
                end

              end
            end

            outputJSON = JSON.pretty_generate(data)

            replacements.each do |k,v|
              say_warning("Replaced #{k} with #{v}") if @options[:debug]
              outputJSON.gsub! k,v
            end

            write_file(@options[:dir] ? "Dashboard_#{data[:id]}_#{data[:title]}.json" : nil, @options[:dir], nil, output) do |f|
              f.puts outputJSON
            end
          end
        end
      end
    end
  end
end
