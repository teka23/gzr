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

RSpec.describe "`gzr role user_ls` command", type: :cli do
  it "executes `gzr role help user_ls` command successfully" do
    output = `gzr role help user_ls`
    expected_output = <<-OUT
Usage:
  gzr role user_ls ROLE_ID

Options:
  -h, [--help], [--no-help]            # Display usage information
      [--fields=FIELDS]                # Fields to display
                                       # Default: id,first_name,last_name,email
      [--plain], [--no-plain]          # print without any extra formatting
      [--csv], [--no-csv]              # output in csv format per RFC4180
      [--all-users], [--no-all-users]  # Show users with this role through a group membership

List the users assigned to a role
    OUT

    expect(output).to eq(expected_output)
  end
end
