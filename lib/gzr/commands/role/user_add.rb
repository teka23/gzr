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
require_relative '../../modules/role'

module Gzr
  module Commands
    class Role
      class UserAdd < Gzr::Command
        include Gzr::Role
        def initialize(role_id,users,options)
          super()
          @role_id = role_id
          @users = users.collect { |u| u.to_i }
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning(@options) if @options[:debug]
          
          with_session do
            users = query_role_users(@role_id, 'id').collect { |u| u.id }
            users += @users
            set_role_users(@role_id,users.uniq)
          end
        end
      end
    end
  end
end
