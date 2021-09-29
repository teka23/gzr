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

RSpec.describe "`gzr group member_users` command", type: :cli do
  it "executes `group member_users --help` command successfully" do
    output = `gzr group member_users --help`
    expect(output).to eq <<-OUT
Usage:
  gzr group member_users GROUP_ID

Options:
  -h, [--help], [--no-help]    # Display usage information
      [--fields=FIELDS]        # Fields to display
                               # Default: id,email,last_name,first_name,personal_space_id,home_space_id
      [--plain], [--no-plain]  # print without any extra formatting
      [--csv], [--no-csv]      # output in csv format per RFC4180

List the users that are members of the given group
    OUT
  end
end
