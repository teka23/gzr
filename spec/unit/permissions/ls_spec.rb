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

require 'gzr/commands/permissions/ls'

RSpec.describe Gzr::Commands::Permissions::Ls do
  it "executes `ls` command successfully" do
    require 'sawyer'
    response_doc = { :permission=>"sudo", :parent=>"see_users", :description=>"Enables sudo-ing" }
    mock_response = double(Sawyer::Resource, response_doc)
    allow(mock_response).to receive(:to_attrs).and_return(response_doc)
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:authenticated?) { true }
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:all_permissions) do 
      return [mock_response]
    end

    output = StringIO.new
    options = {}
    command = Gzr::Commands::Permissions::Ls.new(options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+----------+---------+----------------+
|permission|parent   |description     |
+----------+---------+----------------+
|sudo      |see_users|Enables sudo-ing|
+----------+---------+----------------+
    OUT
  end
end
