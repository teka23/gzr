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

module Gzr
  module Role
    def query_all_roles(fields=nil)
      req = Hash.new
      req[:fields] = fields if fields
      data = Array.new
      begin
        data = @sdk.all_roles(req)
      rescue LookerSDK::NotFound => e
        # do nothing
      rescue LookerSDK::ClientError => e
        say_error "Unable to get all_roles(#{JSON.pretty_generate(req)})"
        say_error e.message
        say_error e.errors if e.errors
        raise
      end
      data
    end
    def query_role(role_id)
      data = nil
      begin
        data = @sdk.role(role_id)
      rescue LookerSDK::NotFound => e
        # do nothing
      rescue LookerSDK::ClientError => e
        say_error "Unable to get role(#{role_id})"
        say_error e.message
        say_error e.errors if e.errors
        raise
      end
      data
    end
    def delete_role(role_id)
      data = nil
      begin
        data = @sdk.delete_role(role_id)
      rescue LookerSDK::NotFound => e
        # do nothing
      rescue LookerSDK::ClientError => e
        say_error "Unable to delete_role(#{role_id})"
        say_error e.message
        say_error e.errors if e.errors
        raise
      end
      data
    end
    def query_role_groups(role_id,fields=nil)
      req = Hash.new
      req[:fields] = fields if fields
      data = Array.new
      begin
        data = @sdk.role_groups(role_id, req)
      rescue LookerSDK::NotFound => e
        # do nothing
      rescue LookerSDK::ClientError => e
        say_error "Unable to get role_groups(#{role_id},#{JSON.pretty_generate(req)})"
        say_error e.message
        say_error e.errors if e.errors
        raise
      end
      data
    end
    def query_role_users(role_id,fields=nil,direct_association_only=true)
      req = Hash.new
      req[:fields] = fields if fields
      req[:direct_association_only] = direct_association_only
      data = Array.new
      begin
        data = @sdk.role_users(role_id, req)
      rescue LookerSDK::NotFound => e
        # do nothing
      rescue LookerSDK::ClientError => e
        say_error "Unable to get role_users(#{role_id},#{JSON.pretty_generate(req)})"
        say_error e.message
        say_error e.errors if e.errors
        raise
      end
      data
    end
    def set_role_groups(role_id,groups=[])
      data = Array.new
      begin
        data = @sdk.set_role_groups(role_id, groups)
      rescue LookerSDK::ClientError => e
        say_error "Unable to call set_role_groups(#{role_id},#{JSON.pretty_generate(groups)})"
        say_error e.message
        say_error e.errors if e.errors
        raise
      end
      data
    end
    def set_role_users(role_id,users=[])
      data = Array.new
      begin
        data = @sdk.set_role_users(role_id, users)
      rescue LookerSDK::ClientError => e
        say_error "Unable to call set_role_users(#{role_id},#{JSON.pretty_generate(users)})"
        say_error e.message
        say_error e.errors if e.errors
        raise
      end
      data
    end
  end
end
