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
      class Top < Gzr::Command
        include Gzr::Space
        def initialize(options)
          super()
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do
            extra_fields = %w(is_shared_root is_users_root is_embed_shared_root is_embed_users_root)
            query_fields = (@options[:fields].split(',') + extra_fields).uniq
            spaces = all_spaces(query_fields.join(','))

            begin
              puts "No spaces found"
              return nil
            end unless spaces && spaces.length > 0

            table_hash = Hash.new
            fields = field_names(@options[:fields])
            table_hash[:header] = fields unless @options[:plain]
            expressions = fields.collect { |fn| field_expression(fn) }
            rows = []
            spaces.each do |h|
              if ( h.is_shared_root || h.is_users_root || h.is_embed_shared_root || h.is_embed_users_root) then
                rows << expressions.collect do |e|
                  eval "h.#{e}"
                end
              end
            end
            table_hash[:rows] = rows
            table = TTY::Table.new(table_hash)
            begin
              if @options[:csv] then
                output.puts render_csv(table)
              else
                output.puts table.render(if @options[:plain] then :basic else :ascii end, alignments: [:right])
              end
            end if table
          end
        end
      end
    end
  end
end
