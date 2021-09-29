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

require 'gzr/commands/space/ls'

RSpec.describe Gzr::Commands::Space::Ls do
  it "executes `space ls` command successfully" do
    require 'sawyer'
    resp_hash = {
      :id=>1,
      :name=>"foo",
      :parent_id=>0,
      :looks=>[
        {
          :id=>2,
          :title=>"bar"
        }
      ],
      :dashboards=>[
        {
          :id=>3,
          :title=>"baz"
        }
      ]
    }
    mock_response = double(Sawyer::Resource, resp_hash)
    allow(mock_response).to receive(:to_attrs).and_return(resp_hash)
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:space) do |look_id,req|
      return mock_response
    end
    resp_hash2 = {
      :id=>4,
      :name=>"buz",
      :parent_id=>1
    }
    mock_response2 = double(Sawyer::Resource, resp_hash2)
    allow(mock_response2).to receive(:to_attrs).and_return(resp_hash2)
    mock_sdk.define_singleton_method(:space_children) do |look_id,req|
      return [mock_response2]
    end

    output = StringIO.new
    options = { :fields=>'parent_id,id,name,looks(id,title),dashboards(id,title)' }
    command = Gzr::Commands::Space::Ls.new("1", options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+---------+--+----+--------+-----------+-------------+----------------+
|parent_id|id|name|looks.id|looks.title|dashboards.id|dashboards.title|
+---------+--+----+--------+-----------+-------------+----------------+
|        0| 1|foo |        |           |             |                |
|        1| 4|buz |        |           |             |                |
|         |  |    |       2|bar        |             |                |
|         |  |    |        |           |            3|baz             |
+---------+--+----+--------+-----------+-------------+----------------+
    OUT
  end
end
