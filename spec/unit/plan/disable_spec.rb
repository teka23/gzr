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

require 'gzr/commands/plan/disable'

RSpec.describe Gzr::Commands::Plan::Disable do
  it "executes `plan disable` command successfully" do
    require 'sawyer'
    plan_response_doc = {
      :id=>1
    }
    mock_plan_response = double(Sawyer::Resource, plan_response_doc)
    allow(mock_plan_response).to receive(:to_attrs).and_return(plan_response_doc)

    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:authenticated?) { true }
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:update_scheduled_plan) do |plan_id,req|
      return mock_plan_response
    end
    output = StringIO.new
    options = {}
    command = Gzr::Commands::Plan::Disable.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq("Disabled plan 1\n")
  end
end
