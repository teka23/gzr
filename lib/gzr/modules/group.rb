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
  module Group
    def query_all_groups(fields=nil, sorts=nil)
      req = {
        :per_page=>128
      }
      req[:fields] = fields if fields
      req[:sorts] = sorts if sorts

      data = Array.new
      page = 1
      loop do
        begin
          req[:page] = page
          scratch_data = @sdk.all_groups(req)
        rescue LookerSDK::ClientError => e
          say_error "Unable to get all_groups(#{JSON.pretty_generate(req)})"
          say_error e.message
          raise
        end
        break if scratch_data.length == 0
        page += 1
        data += scratch_data
      end
      data
    end
    
    def query_group_groups(group_id,fields=nil)
      req = { }
      req[:fields] = fields if fields

      data = Array.new
      begin
        data = @sdk.all_group_groups(group_id,req)
      rescue LookerSDK::NotFound => e
        return []
      rescue LookerSDK::ClientError => e
        say_error "Unable to get all_group_groups(#{group_id},#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
      data
    end

    def query_group_users(group_id,fields=nil,sorts=nil)
      req = {
        :per_page=>128
      }
      req[:fields] = fields if fields
      req[:sorts] = sorts if sorts

      data = Array.new
      page = 1
      loop do
        begin
          req[:page] = page
          scratch_data = @sdk.all_group_users(group_id,req)
        rescue LookerSDK::ClientError => e
          say_error "Unable to get all_group_users(#{group_id},#{JSON.pretty_generate(req)})"
          say_error e.message
          raise
        end
        break if scratch_data.length == 0
        page += 1
        data += scratch_data
      end
      data
    end
    
    def search_groups(name)
      req = {:name => name }
      begin
        return @sdk.search_groups(req)
      rescue LookerSDK::NotFound => e
        return nil
      rescue LookerSDK::ClientError => e
        say_error "Unable to search_groups(#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
    end
    
    def query_group(id, fields=nil)
      req = Hash.new
      req[:fields] = fields if fields
      begin
        return @sdk.group(id,req)
      rescue LookerSDK::NotFound => e
        return nil
      rescue LookerSDK::ClientError => e
        say_error "Unable to find group(#{id},#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
    end
    
    def update_user_attribute_group_value(group_id, attr_id, value)
      req = Hash.new
      req[:value] = value
      begin
        return @sdk.update_user_attribute_group_value(group_id,attr_id, req)
      rescue LookerSDK::ClientError => e
        say_error "Unable to update_user_attribute_group_value(#{group_id},#{attr_id},#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
    end
  end
end
