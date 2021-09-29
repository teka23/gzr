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

require_relative '../../../gzr'
require_relative '../../command'
require_relative '../../modules/dashboard'

module Gzr
  module Commands
    class Dashboard
      class Mv < Gzr::Command
        include Gzr::Dashboard
        def initialize(dashboard_id, target_space_id, options)
          super()
          @dashboard_id = dashboard_id
          @target_space_id = target_space_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}", output: output) if @options[:debug]
          with_session do

            dash = query_dashboard(@dashboard_id)
            raise Gzr::CLI::Error, "Dashboard with id #{@dashboard_id} does not exist" unless dash

            matching_title = search_dashboards_by_title(dash[:title],@target_space_id)
            if matching_title.empty? || matching_title.first[:deleted]
              matching_title = false
            end
            
            if matching_title
              raise Gzr::CLI::Error, "Dashboard #{dash[:title]} already exists in space #{@target_space_id}\nUse --force if you want to overwrite it" unless @options[:force]
              say_ok "Deleting existing dashboard #{matching_title.first[:id]} #{matching_title.first[:title]} in space #{@target_space_id}", output: output
              update_dashboard(matching_title.first[:id],{:deleted=>true})
            end
            update_dashboard(dash[:id],{:space_id=>@target_space_id})
            output.puts "Moved dashboard #{dash[:id]} to space #{@target_space_id}" unless @options[:plain] 
          end
        end
      end
    end
  end
end
