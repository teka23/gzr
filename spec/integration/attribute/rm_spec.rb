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

RSpec.describe "`gzr attribute rm` command", type: :cli do
  it "executes `gzr attribute help rm` command successfully" do
    output = `gzr attribute help rm`
    expected_output = <<-OUT
Usage:
  gzr attribute rm ATTR_ID|ATTR_NAME

Options:
  -h, [--help], [--no-help]    # Display usage information
      [--plain], [--no-plain]  # Provide minimal response information

Delete a user attribute
    OUT

    expect(output).to eq(expected_output)
  end
end
