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

require_relative 'subcommandbase'

module Gzr
  module Commands
    class Space < SubCommandBase

      namespace :space

      desc 'create NAME PARENT_SPACE', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :plain, type: :boolean,
                           desc: 'Provide minimal response information'
      def create(name, parent_space)
        if options[:help]
          invoke :help, ['create']
        else
          require_relative 'space/create'
          Gzr::Commands::Space::Create.new(name, parent_space, options).execute
        end
      end

      desc 'top', 'Retrieve the top level (or root) spaces'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :fields, type: :string, default: 'id,name,is_shared_root,is_users_root,is_embed_shared_root,is_embed_users_root',
                           desc: 'Fields to display'
      method_option :plain, type: :boolean, default: false,
                           desc: 'print without any extra formatting'
      method_option :csv, type: :boolean, default: false,
                           desc: 'output in csv format per RFC4180'
      def top(*)
        if options[:help]
          invoke :help, ['top']
        else
          require_relative 'space/top'
          Gzr::Commands::Space::Top.new(options).execute
        end
      end

      desc 'export SPACE_ID', 'Export a space, including all child looks, dashboards, and spaces.'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :dir, type: :string, default: '.',
                           desc: 'Directory to store output tree'
      method_option :tar, type: :string,
                           desc: 'Tar file to store output'
      method_option :tgz, type: :string,
                           desc: 'TarGZ file to store output'
      method_option :zip, type: :string,
                           desc: 'Zip file to store output'
      def export(starting_space)
        if options[:help]
          invoke :help, ['export']
        else
          require_relative 'space/export'
          Gzr::Commands::Space::Export.new(starting_space,options).execute
        end
      end

      desc 'tree STARTING_SPACE', 'Display the dashbaords, looks, and subspaces or a space in a tree format'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def tree(starting_space)
        if options[:help]
          invoke :help, ['tree']
        else
          require_relative 'space/tree'
          Gzr::Commands::Space::Tree.new(starting_space,options).execute
        end
      end

      desc 'cat SPACE_ID', 'Output the JSON representation of a space to the screen or a file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :dir,  type: :string,
                           desc: 'Directory to get output file'
      def cat(space_id)
        if options[:help]
          invoke :help, ['cat']
        else
          require_relative 'space/cat'
          Gzr::Commands::Space::Cat.new(space_id,options).execute
        end
      end

      desc 'ls FILTER_SPEC', 'list the contents of a space given by space name, space_id, ~ for the current user\'s default space, or ~name / ~number for the home space of a user'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :fields, type: :string, default: 'parent_id,id,name,looks(id,title),dashboards(id,title)',
                           desc: 'Fields to display'
      method_option :plain, type: :boolean, default: false,
                           desc: 'print without any extra formatting'
      method_option :csv, type: :boolean, default: false,
                           desc: 'output in csv format per RFC4180'
      def ls(filter_spec=nil)
        if options[:help]
          invoke :help, ['ls']
        else
          require_relative 'space/ls'
          Gzr::Commands::Space::Ls.new(filter_spec,options).execute
        end
      end

      desc 'rm SPACE_ID', 'Delete a space. The space must be empty or the --force flag specified to deleted subspaces, dashboards, and looks.'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def rm(space_id)
        if options[:help]
          invoke :help, ['rm']
        else
          require_relative 'space/rm'
          Gzr::Commands::Space::Rm.new(space_id,options).execute
        end
      end
    end
  end
end
