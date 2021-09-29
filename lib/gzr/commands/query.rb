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

require_relative 'subcommandbase'

module Gzr
  module Commands
    class Query < SubCommandBase

      namespace :query

      desc 'runquery QUERY_DEF', 'Run query_id, query_slug, or json_query_desc'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :file, type: :string,
                           desc: 'Filename for saved data'
      method_option :format, type: :string, default: 'json',
                           desc: 'One of json,json_detail,csv,txt,html,md,xlsx,sql,png,jpg'
      def runquery(query_def)
        if options[:help]
          invoke :help, ['runquery']
        else
          require_relative 'query/runquery'
          Gzr::Commands::Query::RunQuery.new(query_def,options).execute
        end
      end
    end
  end
end
