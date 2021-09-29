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

RSpec.describe "`gzr space ls` command", type: :cli do
  it "executes `space ls --help` command successfully" do
    output = `gzr space ls --help`
    expect(output).to eq <<-OUT
Usage:
  gzr space ls FILTER_SPEC

Options:
  -h, [--help], [--no-help]    # Display usage information
      [--fields=FIELDS]        # Fields to display
                               # Default: parent_id,id,name,looks(id,title),dashboards(id,title)
      [--plain], [--no-plain]  # print without any extra formatting
      [--csv], [--no-csv]      # output in csv format per RFC4180

list the contents of a space given by space name, space_id, ~ for the current user's default space, or ~name / ~number for the home space of a user
    OUT
  end
end
