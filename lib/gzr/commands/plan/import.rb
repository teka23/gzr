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
require_relative '../../modules/plan'
require_relative '../../modules/user'
require_relative '../../modules/filehelper'

module Gzr
  module Commands
    class Plan
      class Import < Gzr::Command
        include Gzr::Plan
        include Gzr::User
        include Gzr::FileHelper
        def initialize(plan_file, obj_type, obj_id, options)
          super()
          @plan_file = plan_file
          @obj_type = obj_type
          @obj_id = obj_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do

            @me ||= query_me("id")
            

            read_file(@plan_file) do |data|
              plan = nil
              case @obj_type
              when /dashboard/i
                plan = upsert_plan_for_dashboard(@obj_id,@me.id,data)
              when /look/i
                plan = upsert_plan_for_look(@obj_id,@me.id,data)
              else
                raise Gzr::CLI::Error, "Invalid type '#{obj_type}', valid types are look and dashboard"
              end
              output.puts "Imported plan #{plan.id}" unless @options[:plain] 
              output.puts plan.id if @options[:plain] 
            end
          end
        end
      end
    end
  end
end
