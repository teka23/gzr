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
  module Dashboard
    def query_dashboard(dashboard_id)
      data = nil
      begin
        data = @sdk.dashboard(dashboard_id)
        data&.dashboard_filters&.sort! { |a,b| a.row <=> b.row }
        data&.dashboard_layouts&.sort_by! { |v| (v.active ? 0 : 1) }
      rescue LookerSDK::Error => e
        say_error "Error querying dashboard(#{dashboard_id})"
        say_error e.message
        raise
      end
      data
    end

    def delete_dashboard(dash)
      data = nil
      begin
        data = @sdk.delete_dashboard(dash)
      rescue LookerSDK::Error => e
        say_error "Error deleting dashboard(#{dash})"
        say_error e.message
        raise
      end
      data
    end

    def search_dashboards_by_slug(slug, space_id=nil)
      data = []
      begin
        req = { :slug => slug }
        req[:space_id] = space_id if space_id 
        data = @sdk.search_dashboards(req)
        req[:deleted] = true
        data = @sdk.search_dashboards(req) if data.empty?
      rescue LookerSDK::Error => e
        say_error "Error search_dashboards_by_slug(#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
      data
    end

    def search_dashboards_by_title(title, space_id=nil)
      data = []
      begin
        req = { :title => title }
        req[:space_id] = space_id if space_id 
        data = @sdk.search_dashboards(req)
        req[:deleted] = true
        data = @sdk.search_dashboards(req) if data.empty?
      rescue LookerSDK::Error => e
        say_error "Error search_dashboards_by_title(#{JSON.pretty_generate(req)})"
        say_error e.message
        raise
      end
      data
    end

    def create_dashboard(dash)
      begin
        data = @sdk.create_dashboard(dash)
        data&.dashboard_filters&.sort! { |a,b| a.row <=> b.row }
        data&.dashboard_layouts&.sort_by! { |v| (v.active ? 0 : 1) }
      rescue LookerSDK::Error => e
        say_error "Error creating dashboard(#{JSON.pretty_generate(dash)})"
        say_error e.message
        raise
      end
      data
    end

    def update_dashboard(dash_id,dash)
      begin
        data = @sdk.update_dashboard(dash_id,dash)
        data&.dashboard_filters&.sort! { |a,b| a.row <=> b.row }
      rescue LookerSDK::Error => e
        say_error "Error updating dashboard(#{dash_id},#{JSON.pretty_generate(dash)})"
        say_error e.message
        raise
      end
      data
    end

    def create_dashboard_element(dash_elem)
      begin
        data = @sdk.create_dashboard_element(dash_elem)
      rescue LookerSDK::Error => e
        say_error "Error creating dashboard_element(#{JSON.pretty_generate(dash_elem)})"
        say_error e.message
        raise
      end
      data
    end

    def update_dashboard_element(id,dash_elem)
      begin
        data = @sdk.update_dashboard_element(id,dash_elem)
      rescue LookerSDK::Error => e
        say_error "Error updating dashboard_element(#{id},#{JSON.pretty_generate(dash_elem)})"
        say_error e.message
        raise
      end
      data
    end

    def delete_dashboard_element(id)
      begin
        data = @sdk.delete_dashboard_element(id)
      rescue LookerSDK::Error => e
        say_error "Error deleting dashboard_element(#{id})})"
        say_error e.message
        raise
      end
      data
    end

    def get_dashboard_layout(id)
      begin
        data = @sdk.dashboard_layout(id)
      rescue LookerSDK::Error => e
        say_error "Error getting dashboard_layout(#{id})"
        say_error e.message
        raise
      end
      data
    end

    def create_dashboard_layout(dash_layout)
      begin
        data = @sdk.create_dashboard_layout(dash_layout)
      rescue LookerSDK::Error => e
        say_error "Error creating dashboard_layout(#{JSON.pretty_generate(dash_layout)})"
        say_error e.message
        raise
      end
      data
    end

    def update_dashboard_layout(id,dash_layout)
      begin
        data = @sdk.update_dashboard_layout(id,dash_layout)
      rescue LookerSDK::Error => e
        say_error "Error updating dashboard_layout(#{id},#{JSON.pretty_generate(dash_layout)})"
        say_error e.message
        raise
      end
      data
    end

    def delete_dashboard_layout(id)
      begin
        data = @sdk.delete_dashboard_layout(id)
      rescue LookerSDK::Error => e
        say_error "Error deleting dashboard_layout(#{id})"
        say_error e.message
        raise
      end
      data
    end

    def update_dashboard_layout_component(id,component)
      begin
        data = @sdk.update_dashboard_layout_component(id,component)
      rescue LookerSDK::Error => e
        say_error "Error updating dashboard_layout_component(#{id},#{JSON.pretty_generate(component)})"
        say_error e.message
        raise
      end
      data
    end

    def create_dashboard_filter(dash_filter)
      begin
        data = @sdk.create_dashboard_filter(dash_filter)
      rescue LookerSDK::Error => e
        say_error "Error creating dashboard_filter(#{JSON.pretty_generate(dash_filter)})"
        say_error e.message
        raise
      end
      data
    end

    def update_dashboard_filter(id,dash_filter)
      begin
        data = @sdk.update_dashboard_filter(id,dash_filter)
      rescue LookerSDK::Error => e
        say_error "Error updating dashboard_filter(#{id},#{JSON.pretty_generate(dash_filter)})"
        say_error e.message
        raise
      end
      data
    end

    def delete_dashboard_filter(id)
      begin
        data = @sdk.delete_dashboard_filter(id)
      rescue LookerSDK::Error => e
        say_error "Error deleting dashboard_filter(#{id})})"
        say_error e.message
        raise
      end
      data
    end
  end
end
