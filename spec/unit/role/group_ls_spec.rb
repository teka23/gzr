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

require 'gzr/commands/role/group_ls'

RSpec.describe Gzr::Commands::Role::GroupLs do
  it "executes `role group_ls` command successfully" do
    require 'sawyer'
    groups = (100..105).collect do |i|
      group_doc = {
          :id=>i,
          :name=>"Group No#{i}",
      }
      mock_group = double(Sawyer::Resource, group_doc)
      allow(mock_group).to receive(:to_attrs).and_return(group_doc)
      mock_group
    end
    mock_sdk = Object.new
    allow(mock_sdk).to receive(:logout)
    allow(mock_sdk).to receive(:role_groups) do |role_id,body|
      groups
    end
    output = StringIO.new
    options = { :fields=>'id,name' }
    command = Gzr::Commands::Role::GroupLs.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+---+-----------+
| id|name       |
+---+-----------+
|100|Group No100|
|101|Group No101|
|102|Group No102|
|103|Group No103|
|104|Group No104|
|105|Group No105|
+---+-----------+
    OUT
  end
end
