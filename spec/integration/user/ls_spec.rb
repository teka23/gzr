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

RSpec.describe "`gzr user ls` command", type: :cli do
  it "executes `user ls --help` command successfully" do
    output = `gzr user ls --help`
    expect(output).to eq <<-OUT
Usage:
  gzr user ls

Options:
  -h, [--help], [--no-help]              # Display usage information
      [--fields=FIELDS]                  # Fields to display
                                         # Default: id,email,last_name,first_name,personal_space_id,home_space_id
      [--last-login], [--no-last-login]  # Include the time of the most recent login
      [--plain], [--no-plain]            # print without any extra formatting
      [--csv], [--no-csv]                # output in csv format per RFC4180

list all users
    OUT
  end
end
