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
require 'tty-table'

module Gzr
  module Commands
    class Space
      class Ls < Gzr::Command
        include Gzr::Space
        def initialize(filter_spec, options)
          super()
          @filter_spec = filter_spec
          @options = options
        end

        def flatten_data(raw_array)
          rows = raw_array.map do |entry|
            entry.select do |k,v|
              !(v.kind_of?(Array) || v.kind_of?(Hash))
            end
          end
          raw_array.map do |entry|
            entry.select do |k,v|
              v.kind_of? Array
            end.each do |section,section_value|
              section_value.each do |section_entry|
                h = {}
                section_entry.each_pair do |k,v|
                  h[:"#{section}.#{k}"] = v
                end
                rows.push(h)
              end
            end
          end
          rows
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do
            space_ids = process_args([@filter_spec])
            begin
              puts "No spaces match #{@filter_spec}"
              return nil
            end unless space_ids && space_ids.length > 0

            @options[:fields] = 'dashboards(id,title)' if @filter_spec == 'lookml'
            f = @options[:fields]

            data = space_ids.map do |space_id|
              query_space(space_id, f).to_attrs
            end.compact
            space_ids.each do |space_id|
              query_space_children(space_id, 'id,name,parent_id').map {|child| child.to_attrs}.each do |child|
                data.push child
              end
            end


            begin
              puts "No data returned for spaces #{space_ids.inspect}"
              return nil
            end unless data && data.length > 0

            table_hash = Hash.new
            fields = field_names(@options[:fields])
            table_hash[:header] = fields unless @options[:plain]
            table_hash[:rows] = flatten_data(data).map do |row|
              fields.collect do |e|
                row.fetch(e.to_sym,nil)
              end
            end
            table = TTY::Table.new(table_hash)
            alignments = fields.collect do |k|
              (k =~ /id\)*$/) ? :right : :left
            end
            begin
              if @options[:csv] then
                output.puts render_csv(table)
              else
                output.puts table.render(if @options[:plain] then :basic else :ascii end, alignments: alignments)
              end
            end if table
          end
        end
      end
    end
  end
end
