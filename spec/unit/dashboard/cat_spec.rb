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

require 'gzr/commands/dashboard/cat'

RSpec.describe Gzr::Commands::Dashboard::Cat do
  it "executes `dashboard cat` command successfully" do
    require 'sawyer'
    dashboard = { :id=>1, :title=>"foo", :dashboard_elements=>[], :dashboard_layouts=>[] , :dashboard_filters=>[] }
    mock_response = double(Sawyer::Resource, dashboard)
    allow(mock_response).to receive(:to_attrs).and_return(dashboard)
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:dashboard) do |dashboard_id|
      return mock_response
    end

    output = StringIO.new
    options = { dir: nil }
    command = Gzr::Commands::Dashboard::Cat.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
{
  "id": 1,
  "title": "foo",
  "dashboard_elements": [

  ],
  "dashboard_layouts": [

  ],
  "dashboard_filters": [

  ]
}
    OUT
  end
end
