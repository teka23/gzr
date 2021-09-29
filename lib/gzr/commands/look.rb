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
    class Look < SubCommandBase

      namespace :look

      desc 'mv LOOK_ID TARGET_SPACE_ID', 'Move a look to the given space'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :force,  type: :boolean,
                           desc: 'Overwrite a look with the same name in the target space'
      def mv(look_id, target_space_id)
        if options[:help]
          invoke :help, ['mv']
        else
          require_relative 'look/mv'
          Gzr::Commands::Look::Mv.new(look_id, target_space_id, options).execute
        end
      end

      desc 'rm LOOK_ID', 'Delete look given by LOOK_ID'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :soft,  type: :boolean,
                           desc: 'Soft delete the look'
      method_option :restore,  type: :boolean,
                           desc: 'Restore a soft deleted look'
      def rm(look_id)
        if options[:help]
          invoke :help, ['rm']
        else
          require_relative 'look/rm'
          Gzr::Commands::Look::Rm.new(look_id, options).execute
        end
      end

      desc 'import FILE DEST_SPACE_ID', 'Import a look from a file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :plain, type: :boolean,
                           desc: 'Provide minimal response information'
      method_option :force,  type: :boolean,
                           desc: 'Overwrite a look with the same name/slug in the target space'
      def import(file,dest_space_id)
        if options[:help]
          invoke :help, ['import']
        else
          require_relative 'look/import'
          Gzr::Commands::Look::Import.new(file, dest_space_id, options).execute
        end
      end

      desc 'cat LOOK_ID', 'Output the JSON representation of a look to the screen or a file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :dir,  type: :string,
                           desc: 'Directory to store output file'
      method_option :plans,  type: :boolean,
                           desc: 'Include scheduled plans'
      def cat(look_id)
        if options[:help]
          invoke :help, ['cat']
        else
          require_relative 'look/cat'
          Gzr::Commands::Look::Cat.new(look_id, options).execute
        end
      end
    end
  end
end
