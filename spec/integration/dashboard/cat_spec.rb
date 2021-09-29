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

RSpec.describe "`gzr dashboard cat` command", type: :cli do
  it "executes `dashboard cat --help` command successfully" do
    output = `gzr dashboard cat --help`
    expect(output).to eq <<-OUT
Usage:
  gzr dashboard cat DASHBOARD_ID

Options:
  -h, [--help], [--no-help]    # Display usage information
      [--dir=DIR]              # Directory to store output file
      [--plans], [--no-plans]  # Include scheduled plans
      [--transform=TRANSFORM]  # Fully-qualified path to a JSON file describing the transformations to apply

Output the JSON representation of a dashboard to the screen or a file
    OUT
  end
end
