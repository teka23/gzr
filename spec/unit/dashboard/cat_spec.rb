# The MIT License (MIT)

# Copyright (c) 2018 Google

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'gzr/commands/dashboard/cat'

RSpec.describe Gzr::Commands::Dashboard::Cat do
  it "executes `dashboard cat` command successfully" do
    require 'sawyer'
    dashboard = { :id=>1, :title=>"foo", :dashboard_elements=>[], :dashboard_layouts=>[] , :dashboard_filters=>[] }
    mock_response = double(Sawyer::Resource, dashboard)
    allow(mock_response).to receive(:to_attrs).and_return(dashboard)
    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:dashboard) do |dashboard_id|
      return mock_response
    end

    output = StringIO.new
    options = { dir: nil }
    command = Gzr::Commands::Dashboard::Cat.new(1,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq <<-OUT
{
  "id": 1,
  "title": "foo",
  "dashboard_elements": [

  ],
  "dashboard_layouts": [

  ],
  "dashboard_filters": [

  ]
}
    OUT
  end
end
