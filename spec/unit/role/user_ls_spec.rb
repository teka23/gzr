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

require 'gzr/commands/role/user_ls'

RSpec.describe Gzr::Commands::Role::UserLs do
  it "executes `role user_ls` command successfully" do
    require 'sawyer'
    users = (100..105).collect do |i|
      user_doc = {
          :id=>i,
          :first_name=>'User',
          :last_name=>"No#{i}",
          :email=>"User.No#{i}@example.com",
      }
      mock_user = double(Sawyer::Resource, user_doc)
      allow(mock_user).to receive(:to_attrs).and_return(user_doc)
      mock_user
    end
    mock_sdk = Object.new
    allow(mock_sdk).to receive(:logout)
    allow(mock_sdk).to receive(:role_users) do |role_id,body|
      users
    end
    output = StringIO.new
    options = {
      :fields=>'id,first_name,last_name,email'
    }
    command = Gzr::Commands::Role::UserLs.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+---+----------+---------+----------------------+
| id|first_name|last_name|email                 |
+---+----------+---------+----------------------+
|100|User      |No100    |User.No100@example.com|
|101|User      |No101    |User.No101@example.com|
|102|User      |No102    |User.No102@example.com|
|103|User      |No103    |User.No103@example.com|
|104|User      |No104    |User.No104@example.com|
|105|User      |No105    |User.No105@example.com|
+---+----------+---------+----------------------+
    OUT
  end
end
