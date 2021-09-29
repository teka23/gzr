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
    class Dashboard < SubCommandBase

      namespace :dashboard

      desc 'mv DASHBOARD_ID TARGET_SPACE_ID', 'Move a dashboard to the given space'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :force,  type: :boolean,
                           desc: 'Overwrite a dashboard with the same name in the target space'
      def mv(dashboard_id, target_space_id)
        if options[:help]
          invoke :help, ['mv']
        else
          require_relative 'dashboard/mv'
          Gzr::Commands::Dashboard::Mv.new(dashboard_id, target_space_id, options).execute
        end
      end

      desc 'cat DASHBOARD_ID', 'Output the JSON representation of a dashboard to the screen or a file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :dir,  type: :string,
                           desc: 'Directory to store output file'
      method_option :plans,  type: :boolean,
                           desc: 'Include scheduled plans'
      method_option :transform,  type: :string,
                           desc: 'Fully-qualified path to a JSON file describing the transformations to apply'
      def cat(dashboard_id)
        if options[:help]
          invoke :help, ['cat']
        else
          require_relative 'dashboard/cat'
          Gzr::Commands::Dashboard::Cat.new(dashboard_id, options).execute
        end
      end

      desc 'import FILE DEST_SPACE_ID', 'Import a dashboard from a file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :plain, type: :boolean,
                           desc: 'Provide minimal response information'
      method_option :force,  type: :boolean,
                           desc: 'Overwrite a dashboard with the same name/slug in the target space'
      def import(file,dest_space_id)
        if options[:help]
          invoke :help, ['import']
        else
          require_relative 'dashboard/import'
          Gzr::Commands::Dashboard::Import.new(file, dest_space_id, options).execute
        end
      end

      desc 'rm DASHBOARD_ID', 'Remove or delete the given dashboard'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :soft,  type: :boolean,
                           desc: 'Soft delete the dashboard'
      method_option :restore,  type: :boolean,
                           desc: 'Restore a soft deleted dashboard'
      def rm(id)
        if options[:help]
          invoke :help, ['rm']
        else
          require_relative 'dashboard/rm'
          Gzr::Commands::Dashboard::Rm.new(id, options).execute
        end
      end
    end
  end
end
