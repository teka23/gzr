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

RSpec.describe "`gzr dashboard rm` command", type: :cli do
  it "executes `dashboard rm --help` command successfully" do
    output = `gzr dashboard rm --help`
    expect(output).to eq <<-OUT
Usage:
  gzr dashboard rm DASHBOARD_ID

Options:
  -h, [--help], [--no-help]        # Display usage information
      [--soft], [--no-soft]        # Soft delete the dashboard
      [--restore], [--no-restore]  # Restore a soft deleted dashboard

Remove or delete the given dashboard
    OUT
  end
end
