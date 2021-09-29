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

require 'gzr/commands/space/top'

RSpec.describe Gzr::Commands::Space::Top do
  it "executes `top` command successfully" do
    require 'sawyer'
    mock_spaces = Array.new
    (1..6).each do |i|
      h = {
        :id=>i,
        :name=>"Space #{i}",
        :is_shared_root=>i==1,
        :is_users_root=>i==2,
        :is_embed_shared_root=>i==5,
        :is_embed_users_root=>i==5,
      }
      m = double(Sawyer::Resource, h)
      allow(m).to receive(:to_attrs).and_return(h)
      allow(m).to receive(:name).and_return(h[:name])
      allow(m).to receive(:is_shared_root).and_return(h[:is_shared_root])
      allow(m).to receive(:is_users_root).and_return(h[:is_users_root])
      allow(m).to receive(:is_embed_shared_root).and_return(h[:is_embed_shared_root])
      allow(m).to receive(:is_embed_users_root).and_return(h[:is_embed_users_root])
      mock_spaces << m
    end
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:all_spaces) do |body|
      return mock_spaces
    end

    output = StringIO.new
    options = {:fields => 'id,name,is_shared_root,is_users_root,is_embed_shared_root,is_embed_users_root'}
    command = Gzr::Commands::Space::Top.new(options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
+--+-------+--------------+-------------+--------------------+-------------------+
|id|name   |is_shared_root|is_users_root|is_embed_shared_root|is_embed_users_root|
+--+-------+--------------+-------------+--------------------+-------------------+
| 1|Space 1|true          |false        |false               |false              |
| 2|Space 2|false         |true         |false               |false              |
| 5|Space 5|false         |false        |true                |true               |
+--+-------+--------------+-------------+--------------------+-------------------+
    OUT
  end
end
