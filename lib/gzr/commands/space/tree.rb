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
require 'tty-tree'

# The tty-tree tool is built on the idea of handling directories, so it does
# parsing based on slashs (or backslashs on Windows). If those characters are
# in object names, tty-tree pulls them out.
# This monkey patch disables that.

module TTY
  class Tree
    class Node
      def initialize(path, parent, prefix, level)
        if path.is_a? String
          # strip null bytes from the string to avoid throwing errors
          path = path.delete("\0")
        end

        @path = path
        @name   = path
        @parent = parent
        @prefix = prefix
        @level  = level
      end
    end
  end
end

module Gzr
  module Commands
    class Space
      class Tree < Gzr::Command
        include Gzr::Space
        def initialize(filter_spec, options)
          super()
          @filter_spec = filter_spec
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do
            space_ids = process_args([@filter_spec])

            tree_data = Hash.new
            
            space_ids.each do |space_id| 
              s = query_space(space_id, "id,name,parent_id,looks(id,title),dashboards(id,title)")
              space_name = s.name
              space_name = "nil (#{s.id})" unless space_name 
              space_name = "\"#{space_name}\"" if ((space_name != space_name.strip) || (space_name.length == 0))
              space_name += " (#{space_id})" unless space_ids.length == 1
              tree_data[space_name] =
                [ recurse_spaces(s.id) ] +
                s.looks.map { |l| "(l) #{l.title}" } +
                  s.dashboards.map { |d| "(d) #{d.title}" }
            end
            tree = TTY::Tree.new(tree_data)
            output.puts tree.render
          end
        end

        def recurse_spaces(space_id)
          data = query_space_children(space_id, "id,name,parent_id,looks(id,title),dashboards(id,title)")
          tree_branch = Hash.new
          data.each do |s|
            space_name = s.name
            space_name = "nil (#{s.id})" unless space_name 
            space_name = "\"#{space_name}\"" if ((space_name != space_name.strip) || (space_name.length == 0))
            tree_branch[space_name] =
              [ recurse_spaces(s.id) ] +
              s.looks.map { |l| "(l) #{l.title}" } +
              s.dashboards.map { |d| "(d) #{d.title}" }
          end
          tree_branch
        end
      end
    end
  end
end
