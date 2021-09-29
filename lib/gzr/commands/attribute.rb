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
    class Attribute < Thor

      namespace :attribute

      desc 'set_group_value GROUP_ID|GROUP_NAME ATTR_ID|ATTR_NAME VALUE', 'Set a user attribute value for a group'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def set_group_value(group,attr,value)
        if options[:help]
          invoke :help, ['set_group_value']
        else
          require_relative 'attribute/set_group_value'
          Gzr::Commands::Attribute::SetGroupValue.new(group,attr,value,options).execute
        end
      end

      desc 'get_group_value GROUP_ID|GROUP_NAME ATTR_ID|ATTR_NAME', 'Retrieve a user attribute value for a group'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def get_group_value(group,attr)
        if options[:help]
          invoke :help, ['get_group_value']
        else
          require_relative 'attribute/get_group_value'
          Gzr::Commands::Attribute::GetGroupValue.new(group,attr,options).execute
        end
      end

      desc 'rm ATTR_ID|ATTR_NAME', 'Delete a user attribute'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :plain, type: :boolean,
                           desc: 'Provide minimal response information'
      def rm(attr)
        if options[:help]
          invoke :help, ['rm']
        else
          require_relative 'attribute/rm'
          Gzr::Commands::Attribute::Rm.new(attr,options).execute
        end
      end

      desc 'import FILE', 'Import a user attribute from a file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :plain, type: :boolean,
                           desc: 'Provide minimal response information'
      method_option :force,  type: :boolean,
                           desc: 'If the user attribute already exists, modify it'
      def import(file)
        if options[:help]
          invoke :help, ['import']
        else
          require_relative 'attribute/import'
          Gzr::Commands::Attribute::Import.new(file,options).execute
        end
      end

      desc 'create ATTR_NAME [ATTR_LABEL] [OPTIONS]', 'Create or modify an attribute'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :plain, type: :boolean,
                           desc: 'Provide minimal response information'
      method_option :force,  type: :boolean,
                           desc: 'If the user attribute already exists, modify it'
      method_option :type, type: :string, default: 'string',
                           desc: '"string", "number", "datetime", "yesno", "zipcode"'
      method_option :'default-value', type: :string,
                           desc: 'default value to be used if one not otherwise set'
      method_option :'is-hidden', type: :boolean, default: false,
                           desc: 'can a non-admin user view the value'
      method_option :'can-view', type: :boolean, default: true,
                           desc: 'can a non-admin user view the value'
      method_option :'can-edit', type: :boolean, default: true,
                           desc: 'can a user change the value themself'
      method_option :'domain-whitelist', type: :string,
                          desc: 'what domains can receive the value of a hidden attribute.' 
      def create(attr_name, attr_label=nil)
        if options[:help]
          invoke :help, ['create']
        else
          require_relative 'attribute/create'
          Gzr::Commands::Attribute::Create.new(attr_name, attr_label, options).execute
        end
      end

      desc 'cat ATTR_ID|ATTR_NAME', 'Output json information about an attribute to screen or file'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :fields, type: :string,
                           desc: 'Fields to display'
      method_option :dir,  type: :string,
                           desc: 'Directory to store output file'
      def cat(attr)
        if options[:help]
          invoke :help, ['cat']
        else
          require_relative 'attribute/cat'
          Gzr::Commands::Attribute::Cat.new(attr,options).execute
        end
      end

      desc 'ls', 'List all the defined user attributes'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :fields, type: :string, default: 'id,name,label,type,default_value',
                           desc: 'Fields to display'
      method_option :plain, type: :boolean, default: false,
                           desc: 'print without any extra formatting'
      method_option :csv, type: :boolean, default: false,
                           desc: 'output in csv format per RFC4180'
      def ls(*)
        if options[:help]
          invoke :help, ['ls']
        else
          require_relative 'attribute/ls'
          Gzr::Commands::Attribute::Ls.new(options).execute
        end
      end
    end
  end
end
