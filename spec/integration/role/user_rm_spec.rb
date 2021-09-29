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

RSpec.describe "`gzr role user_rm` command", type: :cli do
  it "executes `gzr role help user_rm` command successfully" do
    output = `gzr role help user_rm`
    expected_output = <<-OUT
Usage:
  gzr role user_rm ROLE_ID USER_ID USER_ID USER_ID ...

Options:
  -h, [--help], [--no-help]  # Display usage information

Remove indicated users from role
    OUT

    expect(output).to eq(expected_output)
  end
end
