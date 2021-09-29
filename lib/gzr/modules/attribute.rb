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
  module Attribute
    def query_user_attribute(attr_id,fields=nil)
      data = nil
      begin
        req = {}
        req[:fields] = fields if fields
        data = @sdk.user_attribute(attr_id,req)
      rescue LookerSDK::NotFound => e
        # do nothing
      rescue LookerSDK::Error => e
        say_error "Error querying user_attribute(#{attr_id},#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
      data
    end

    def query_all_user_attributes(fields=nil, sorts=nil)
      data = nil
      begin
        req = {}
        req[:fields] = fields if fields
        req[:sorts] = sorts if sorts
        data = @sdk.all_user_attributes(req)
      rescue LookerSDK::Error => e
        say_error "Error querying all_user_attributes(#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
      data
    end

    def get_attribute_by_name(name, fields = nil)
      data = query_all_user_attributes(fields).select {|a| a.name == name}
      return nil if data.empty?
      data.first
    end

    def get_attribute_by_label(label, fields = nil)
      data = query_all_user_attributes(fields).select {|a| a.label == label}
      return nil if data.empty?
      data.first
    end

    def create_attribute(attr)
      data = nil
      begin
        data = @sdk.create_user_attribute(attr)
      rescue LookerSDK::Error => e
        say_error "Error creating user_attribute(#{JSON.pretty_generate(attr)})"
        say_error e.message
        raise
      end
      data
    end

    def update_attribute(id,attr)
      data = nil
      begin
        data = @sdk.update_user_attribute(id,attr)
      rescue LookerSDK::Error => e
        say_error "Error updating user_attribute(#{id},#{JSON.pretty_generate(attr)})"
        say_error e.message
        raise
      end
      data
    end

    def delete_user_attribute(id)
      data = nil
      begin
        data = @sdk.delete_user_attribute(id)
      rescue LookerSDK::Error => e
        say_error "Error deleting user_attribute(#{id})"
        say_error e.message
        raise
      end
      data
    end

    def query_all_user_attribute_group_values(attr_id, fields=nil)
      begin
        req = {}
        req[:fields] = fields if fields
        return @sdk.all_user_attribute_group_values(attr_id,req)
      rescue LookerSDK::NotFound => e
        return nil
      rescue LookerSDK::Error => e
        say_error "Error querying all_user_attribute_group_values(#{attr_id},#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
    end

    def query_user_attribute_group_value(group_id, attr_id)
      data = query_all_user_attribute_group_values(attr_id)&.select {|a| a.group_id == group_id}
      return nil if data.nil? || data.empty?
      data.first
    end

    def upsert_user_attribute(source, force=false, output: $stdout)
      name_used = get_attribute_by_name(source[:name])
      if name_used
        raise(Gzr::CLI::Error, "Attribute #{source[:name]} already exists and can't be modified") if name_used[:is_system]
        raise(Gzr::CLI::Error, "Attribute #{source[:name]} already exists\nUse --force if you want to overwrite it") unless @options[:force]
      end

      label_used = get_attribute_by_label(source[:label])
      if label_used
        raise(Gzr::CLI::Error, "Attribute with label #{source[:label]} already exists and can't be modified") if label_used[:is_system]
        raise(Gzr::CLI::Error, "Attribute with label #{source[:label]} already exists\nUse --force if you want to overwrite it") unless force
      end

      existing = name_used || label_used
      if existing
        upd_attr = source.select do |k,v|
          keys_to_keep('update_user_attribute').include?(k) && !(name_used[k] == v)
        end

        return update_attribute(existing.id,upd_attr)
      else
        new_attr = source.select do |k,v|
          (keys_to_keep('create_user_attribute') - [:hidden_value_domain_whitelist]).include? k
        end
        new_attr[:hidden_value_domain_whitelist] = source[:hidden_value_domain_whitelist] if source[:value_is_hidden] && source[:hidden_value_domain_whitelist]

        return create_attribute(new_attr)
      end
    end
  end
end