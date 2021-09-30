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

require 'thor'

module Gzr
  module Commands
    class Role < Thor

      namespace :role

      desc 'group_rm ROLE_ID GROUP_ID GROUP_ID GROUP_ID ...', 'Remove indicated groups from role'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def group_rm(role_id, *groups)
        if options[:help]
          invoke :help, ['group_rm']
        else
          require_relative 'role/group_rm'
          Gzr::Commands::Role::GroupRm.new(role_id, groups, options).execute
        end
      end

      desc 'user_rm ROLE_ID USER_ID USER_ID USER_ID ...', 'Remove indicated users from role'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def user_rm(role_id,*users)
        if options[:help]
          invoke :help, ['user_rm']
        else
          require_relative 'role/user_rm'
          Gzr::Commands::Role::UserRm.new(role_id,users,options).execute
        end
      end

      desc 'group_add ROLE_ID GROUP_ID GROUP_ID GROUP_ID ...', 'Add indicated groups to role'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def group_add(role_id,*groups)
        if options[:help]
          invoke :help, ['group_add']
        else
          require_relative 'role/group_add'
          Gzr::Commands::Role::GroupAdd.new(role_id, groups, options).execute
        end
      end

      desc 'user_add ROLE_ID USER_ID USER_ID USER_ID ...', 'Add indicated users to role'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def user_add(role_id,*users)
        if options[:help]
          invoke :help, ['user_add']
        else
          require_relative 'role/user_add'
          Gzr::Commands::Role::UserAdd.new(role_id,users,options).execute
        end
      end

      desc 'group_ls ROLE_ID', 'List the groups assigned to a role'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :fields, type: :string, default: 'id,name,external_group_id',
                           desc: 'Fields to display'
      method_option :plain, type: :boolean, default: false,
                           desc: 'print without any extra formatting'
      method_option :csv, type: :boolean, default: false,
                           desc: 'output in csv format per RFC4180'
      def group_ls(role_id)
        if options[:help]
          invoke :help, ['group_ls']
        else
          require_relative 'role/group_ls'
          Gzr::Commands::Role::GroupLs.new(role_id,options).execute
        end
      end

      desc 'user_ls ROLE_ID', 'List the users assigned to a role'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :fields, type: :string, default: 'id,first_name,last_name,email',
                           desc: 'Fields to display'
      method_option :plain, type: :boolean, default: false,
                           desc: 'print without any extra formatting'
      method_option :csv, type: :boolean, default: false,
                           desc: 'output in csv format per RFC4180'
      method_option :all_users, type: :boolean, default: false,
                           desc: 'Show users with this role through a group membership'
      def user_ls(role_id)
        if options[:help]
          invoke :help, ['user_ls']
        else
          require_relative 'role/user_ls'
          Gzr::Commands::Role::UserLs.new(role_id,options).execute
        end
      end

      desc 'rm ROLE_ID', 'Delete a role'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def rm(role_id)
        if options[:help]
          invoke :help, ['rm']
        else
          require_relative 'role/rm'
          Gzr::Commands::Role::Rm.new(role_id,options).execute
        end
      end

      desc 'cat ROLE_ID', 'Output the JSON representation of a role to screen/file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :dir,  type: :string,
                           desc: 'Directory to get output file'
      def cat(role_id)
        if options[:help]
          invoke :help, ['cat']
        else
          require_relative 'role/cat'
          Gzr::Commands::Role::Cat.new(role_id,options).execute
        end
      end

      desc 'ls', 'Display all roles'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :fields, type: :string, default: 'id,name,permission_set(id,name,permissions),model_set(id,name,models)',
                           desc: 'Fields to display'
      method_option :plain, type: :boolean, default: false,
                           desc: 'print without any extra formatting'
      method_option :csv, type: :boolean, default: false,
                           desc: 'output in csv format per RFC4180'
      def ls(*)
        if options[:help]
          invoke :help, ['ls']
        else
          require_relative 'role/ls'
          Gzr::Commands::Role::Ls.new(options).execute
        end
      end
    end
  end
end
