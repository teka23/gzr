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

require 'gzr/commands/plan/run'

RSpec.describe Gzr::Commands::Plan::RunIt do
  it "executes `plan run` command successfully" do
    require 'sawyer'
    mock_response = double(Sawyer::Resource, { :id=>1, :name=>"foo" })
    allow(mock_response).to receive(:to_attrs).and_return({ :id=>1, :name=>"foo" })
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:scheduled_plan) do |plan_id, body|
      return mock_response
    end
    mock_sdk.define_singleton_method(:scheduled_plan_run_once) do |body|
      return
    end

    output = StringIO.new
    options = {}
    command = Gzr::Commands::Plan::RunIt.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq("Executed plan 1\n")
  end
end
