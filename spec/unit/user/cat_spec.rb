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

require 'gzr/commands/user/cat'

RSpec.describe Gzr::Commands::User::Cat do
  it "executes `user cat` command successfully" do
    require 'sawyer'
    mock_response = double(Sawyer::Resource, { :id=>1, :last_name=>"foo", :first_name=>"bar", :email=>"fbar@my.company.com" })
    allow(mock_response).to receive(:to_attrs).and_return({ :id=>1, :last_name=>"foo", :first_name=>"bar", :email=>"fbar@my.company.com" })
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:user) do |user_id,body|
      return mock_response
    end

    output = StringIO.new
    options = {}
    command = Gzr::Commands::User::Cat.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
{
  "id": 1,
  "last_name": "foo",
  "first_name": "bar",
  "email": "fbar@my.company.com"
}
    OUT
  end
end
