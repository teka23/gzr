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

require 'gzr/commands/group/member_users'

RSpec.describe Gzr::Commands::Group::MemberUsers do
  it "executes `member_users` command successfully" do
    require 'sawyer'
    mock_response_doc = { :id=>1, :last_name=>"foo", :first_name=>"bar", :email=>"fbar@my.company.com" }
    mock_response = double(Sawyer::Resource, mock_response_doc)
    allow(mock_response).to receive(:to_attrs).and_return(mock_response_doc)
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:all_group_users) do |group_id,body|
      return body[:page] == 1 ? [mock_response] : []
    end

    output = StringIO.new
    options = { :fields=>'id,last_name,first_name,email' }
    command = Gzr::Commands::Group::MemberUsers.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+--+---------+----------+-------------------+
|id|last_name|first_name|email              |
+--+---------+----------+-------------------+
| 1|foo      |bar       |fbar@my.company.com|
+--+---------+----------+-------------------+
    OUT
  end
end
