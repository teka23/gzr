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

RSpec.describe "`gzr attribute import` command", type: :cli do
  it "executes `gzr attribute help import` command successfully" do
    output = `gzr attribute help import`
    expected_output = <<-OUT
Usage:
  gzr attribute import FILE

Options:
  -h, [--help], [--no-help]    # Display usage information
      [--plain], [--no-plain]  # Provide minimal response information
      [--force]                # If the user attribute already exists, modify it

Import a user attribute from a file
    OUT

    expect(output).to eq(expected_output)
  end
end
