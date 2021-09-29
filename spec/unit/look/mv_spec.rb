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

require 'gzr/commands/look/mv'

RSpec.describe Gzr::Commands::Look::Mv do
  look_response_doc = {
    :id=>31415,
    :title=>"Daily Profit",
    :description=>"Total profit by day for the last 100 days",
    :query_id=>555,
    :user_id=>1000,
    :space_id=>1,
    :slug=>"123xyz"
  }.freeze

  define_method :mock_sdk do |block_hash={}|
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:authenticated?) { true }
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:look) do |id|
      if block_hash && block_hash[:look]
        block_hash[:look].call(id)
      end
      doc = look_response_doc.dup
      HashResponse.new(doc)
    end
    mock_sdk.define_singleton_method(:update_look) do |id,req|
      if block_hash && block_hash[:update_look]
        block_hash[:update_look].call(id,req)
      end
      doc = look_response_doc.dup
      doc.merge!(req)
      HashResponse.new(doc)
    end
    mock_sdk.define_singleton_method(:search_looks) do |req|
      if req&.fetch(:space_id,nil) == 2 && req&.fetch(:title,nil) == "Daily Profit"
        []
      else
        []
      end
    end
    mock_sdk
  end

  it "executes `look mv` command successfully" do
    output = StringIO.new
    options = {}
    command = Gzr::Commands::Look::Mv.new(31415,2,options)

    command.instance_variable_set(:@sdk, mock_sdk())

    command.execute(output: output)

    expect(output.string).to eq("Moved look 31415 to space 2\n")
  end
end
