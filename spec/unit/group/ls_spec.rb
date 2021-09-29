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

require 'gzr/commands/group/ls'

RSpec.describe Gzr::Commands::Group::Ls do
  it "executes `ls` command successfully" do
    require 'sawyer'
    mock_response_doc = { :id=>1, :name=>"foo", :user_count=>5, :contains_current_user=>false, :externally_managed=>nil, :external_group_id=>nil }
    mock_response = double(Sawyer::Resource, mock_response_doc)
    allow(mock_response).to receive(:to_attrs).and_return(mock_response_doc)
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:all_groups) do |body|
      return body[:page] == 1 ? [mock_response] : []
    end

    output = StringIO.new
    options = { :fields=>'id,name,user_count,contains_current_user,externally_managed,external_group_id' }
    command = Gzr::Commands::Group::Ls.new(options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+--+----+----------+---------------------+------------------+-----------------+
|id|name|user_count|contains_current_user|externally_managed|external_group_id|
+--+----+----------+---------------------+------------------+-----------------+
| 1|foo |         5|false                |                  |                 |
+--+----+----------+---------------------+------------------+-----------------+
    OUT
  end
end
