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

require 'gzr/commands/connection/ls'

RSpec.describe Gzr::Commands::Connection::Ls do
  it "executes `ls` command successfully" do
    require 'sawyer'
    response_doc = { :name=>"foo", :dialect=>"mysql", :host=>"db.example.com", :port=>3306, :database=>"looker", :schema=>"test" }
    mock_response = double(Sawyer::Resource, response_doc)
    allow(mock_response).to receive(:to_attrs).and_return(response_doc)
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:authenticated?) { true }
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:all_connections) do |req|
      return [mock_response]
    end

    output = StringIO.new
    options = { :fields=>'name,dialect,host,port,database,schema' }
    command = Gzr::Commands::Connection::Ls.new(options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+----+-------+--------------+----+--------+------+
|name|dialect|host          |port|database|schema|
+----+-------+--------------+----+--------+------+
|foo |mysql  |db.example.com|3306|looker  |test  |
+----+-------+--------------+----+--------+------+
    OUT
  end
end
