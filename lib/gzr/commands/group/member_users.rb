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
require 'tty-table'

module Gzr
  module Commands
    class Group
      class MemberUsers < Gzr::Command
        include Gzr::Group
        def initialize(group_id,options)
          super()
          @group_id = group_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning(@options) if @options[:debug]
          with_session do
            data = query_group_users(@group_id,@options[:fields],"id")
            begin
              say_ok "No users found"
              return nil
            end unless data && data.length > 0

            table_hash = Hash.new
            fields = field_names(@options[:fields])
            table_hash[:header] = fields unless @options[:plain]
            expressions = fields.collect { |fn| field_expression(fn) }
            table_hash[:rows] = data.map do |row|
              expressions.collect do |e|
                eval "row.#{e}"
              end
            end
            table = TTY::Table.new(table_hash)
            alignments = fields.collect do |k|
              next :left if k == "external_group_id"
              (k =~ /(id|count)$/) ? :right : :left
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
