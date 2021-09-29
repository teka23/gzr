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

module Gzr
  module Commands
    class Plan
      class RunIt < Gzr::Command
        include Gzr::Plan
        def initialize(plan_id,options)
          super()
          @plan_id = plan_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do
            plan = query_scheduled_plan(@plan_id)&.to_attrs
            # The api call scheduled_plan_run_once is an odd duck. It accepts
            # the output of any of the calls to retrieve a scheduled plan
            # even though many of the attributes passed are marked read-only.
            # Furthermore, if there is a "secret" - like the password for 
            # sftp or s3 - it will match the plan body up with the plan
            # as known in the server and if they are identical apart from
            # the secret, the api will effectively include to secret in order
            # execute the plan.
            plan.delete(:id)
            run_scheduled_plan(plan)
            output.puts "Executed plan #{@plan_id}" unless @options[:plain] 
          end
        end
      end
    end
  end
end
