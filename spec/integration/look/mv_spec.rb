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

RSpec.describe "`gzr look mv` command", type: :cli do
  it "executes `gzr look help mv` command successfully" do
    output = `gzr look help mv`
    expected_output = <<-OUT
Usage:
  gzr look mv LOOK_ID TARGET_SPACE_ID

Options:
  -h, [--help], [--no-help]  # Display usage information
      [--force]              # Overwrite a look with the same name in the target space

Move a look to the given space
    OUT

    expect(output).to eq(expected_output)
  end
end
