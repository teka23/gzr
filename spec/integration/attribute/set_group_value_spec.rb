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

RSpec.describe "`gzr attribute set_group_value` command", type: :cli do
  it "executes `gzr attribute help set_group_value` command successfully" do
    output = `gzr attribute help set_group_value`
    expected_output = <<-OUT
Usage:
  gzr attribute set_group_value GROUP_ID|GROUP_NAME ATTR_ID|ATTR_NAME VALUE

Options:
  -h, [--help], [--no-help]  # Display usage information

Set a user attribute value for a group
    OUT

    expect(output).to eq(expected_output)
  end
end
