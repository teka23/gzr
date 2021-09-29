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

RSpec.describe "`gzr space tree` command", type: :cli do
  it "executes `space tree --help` command successfully" do
    output = `gzr space tree --help`
    expect(output).to eq <<-OUT
Usage:
  gzr space tree STARTING_SPACE

Options:
  -h, [--help], [--no-help]  # Display usage information

Display the dashbaords, looks, and subspaces or a space in a tree format
    OUT
  end
end
