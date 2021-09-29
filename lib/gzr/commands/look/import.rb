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
require_relative '../../modules/look'
require_relative '../../modules/user'
require_relative '../../modules/plan'
require_relative '../../modules/filehelper'

module Gzr
  module Commands
    class Look
      class Import < Gzr::Command
        include Gzr::Look
        include Gzr::User
        include Gzr::Plan
        include Gzr::FileHelper
        def initialize(file, dest_space_id, options)
          super()
          @file = file
          @dest_space_id = dest_space_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          say_warning("options: #{@options.inspect}") if @options[:debug]
          with_session do

            @me ||= query_me("id")

            read_file(@file) do |data|
              look = upsert_look(@me.id,create_fetch_query(data[:query]).id,@dest_space_id,data,output: output)
              upsert_plans_for_look(look.id,@me.id,data[:scheduled_plans]) if data[:scheduled_plans]
              output.puts "Imported look #{look.id}" unless @options[:plain] 
              output.puts look.id if @options[:plain] 
            end
          end
        end
      end
    end
  end
end
