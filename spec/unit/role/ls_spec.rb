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

require 'gzr/commands/role/ls'

RSpec.describe Gzr::Commands::Role::Ls do
  it "executes `role ls` command successfully" do
    require 'sawyer'
    roles = (100..105).collect do |i|
      role_doc = {
          :id=>i,
          :name=>"Role #{i}"
      }
      mock_role = double(Sawyer::Resource, role_doc)
      allow(mock_role).to receive(:to_attrs).and_return(role_doc)
      mock_role
    end
    mock_sdk = Object.new
    allow(mock_sdk).to receive(:logout)
    allow(mock_sdk).to receive(:all_roles) do |body|
      roles
    end
    output = StringIO.new
    options = { :fields=>'id,name' }
    command = Gzr::Commands::Role::Ls.new(options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+---+--------+
| id|name    |
+---+--------+
|100|Role 100|
|101|Role 101|
|102|Role 102|
|103|Role 103|
|104|Role 104|
|105|Role 105|
+---+--------+
    OUT
  end
end
