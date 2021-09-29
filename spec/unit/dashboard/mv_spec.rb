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

require 'gzr/commands/dashboard/mv'

RSpec.describe Gzr::Commands::Dashboard::Mv do
  dash_response_doc = {
      :id=>500,
      :title=>"Original Dash",
      :description=> "Description of the Dash",
      :slug=> "123xyz",
      :space_id=> 1,
      :deleted=> false,
      :dashboard_filters=>[],
      :dashboard_elements=>[],
      :dashboard_layouts=>[]
    }.freeze

  operations = {
      "update_dashboard"=>
      {
        :info=>{
          :parameters=>[
            {
              "name": "dashboard_id",
              "in": "path",
              "description": "Id of dashboard",
              "required": true,
              "type": "string"
            },
            {
              :in=>"body",
              :schema=>{ :$ref=>"#/definitions/Dashboard" }
            }
          ]
        }
      }
    }.freeze

  define_method :mock_sdk do |block_hash={}|
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:authenticated?) { true }
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:operations) { operations }
    mock_sdk.define_singleton_method(:dashboard) do |id|
      if block_hash && block_hash[:dashboard]
        block_hash[:dashboard].call(id)
      end
      doc = dash_response_doc.dup
      HashResponse.new(doc)
    end

    mock_sdk.define_singleton_method(:update_dashboard) do |id,req|
      if block_hash && block_hash[:update_dashboard]
        block_hash[:update_dashboard].call(id,req)
      end
      doc = dash_response_doc.dup
      doc.merge!(req)
      HashResponse.new(doc)
    end
    mock_sdk.define_singleton_method(:search_dashboards) do |req|
      if req&.fetch(:space_id,nil) == 2 && req&.fetch(:title,nil) == 'Original Dash'
        []
      end
    end
    mock_sdk
  end

  it "executes `mv` when no conflicting dashboards exist" do
    output = StringIO.new
    options = {}
    command = Gzr::Commands::Dashboard::Mv.new(500, 2, options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq("Moved dashboard 500 to space 2\n")
  end

end
