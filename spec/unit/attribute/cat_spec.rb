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

require 'gzr/commands/attribute/cat'

RSpec.describe Gzr::Commands::Attribute::Cat do
  attrs = [
    {
      :id=>1,
      :name=>"attribute_1",
      :label=>"Attribute 1",
      :type=>"string",
      :default_value=>nil,
      :is_system=>true,
      :is_permanent=>nil,
      :value_is_hidden=>false,
      :user_can_view=>true,
      :user_can_edit=>true,
      :hidden_value_domain_whitelist=>nil
    }.freeze,
    {
      :id=>2,
      :name=>"attribute_2",
      :label=>"Attribute 2",
      :type=>"number",
      :default_value=>5,
      :is_system=>false,
      :is_permanent=>nil,
      :value_is_hidden=>false,
      :user_can_view=>true,
      :user_can_edit=>true,
      :hidden_value_domain_whitelist=>nil
    }.freeze,
    {
      :id=>3,
      :name=>"attribute_3",
      :label=>"Attribute 3",
      :type=>"string",
      :default_value=>nil,
      :is_system=>false,
      :is_permanent=>nil,
      :value_is_hidden=>false,
      :user_can_view=>true,
      :user_can_edit=>false,
      :hidden_value_domain_whitelist=>nil
    }.freeze
  ]

  define_method :mock_sdk do |block_hash={}|
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:authenticated?) { true }
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:all_user_attributes) do |req|
      if block_hash && block_hash[:all_user_attributes]
        block_hash[:all_user_attributes].call(req)
      end
      attrs.map {|a| HashResponse.new(a)}
    end
    mock_sdk.define_singleton_method(:user_attribute) do |id,req|
      if block_hash && block_hash[:user_attribute]
        block_hash[:user_attribute].call(id,req)
      end
      found = attrs.select {|a| a[:id] == id.to_i }
      return HashResponse.new(found.first) if found && !found.empty?
      nil
    end
    mock_sdk
  end

  it "executes `attribute cat` command successfully with id" do
    output = StringIO.new
    options = {}
    command = Gzr::Commands::Attribute::Cat.new("3",options)

    command.instance_variable_set(:@sdk, mock_sdk())

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
{
  "id": 3,
  "name": "attribute_3",
  "label": "Attribute 3",
  "type": "string",
  "default_value": null,
  "is_system": false,
  "is_permanent": null,
  "value_is_hidden": false,
  "user_can_view": true,
  "user_can_edit": false,
  "hidden_value_domain_whitelist": null
}
    OUT
  end

  it "executes `attribute cat` command successfully with name" do
    output = StringIO.new
    options = {}
    command = Gzr::Commands::Attribute::Cat.new("attribute_3",options)

    command.instance_variable_set(:@sdk, mock_sdk())

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
{
  "id": 3,
  "name": "attribute_3",
  "label": "Attribute 3",
  "type": "string",
  "default_value": null,
  "is_system": false,
  "is_permanent": null,
  "value_is_hidden": false,
  "user_can_view": true,
  "user_can_edit": false,
  "hidden_value_domain_whitelist": null
}
    OUT
  end
end
