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

RSpec.describe "`gzr plan` command", type: :cli do
  it "executes `gzr help plan` command successfully" do
    output = `gzr help plan`
    expected_output = <<-OUT
Commands:
  gzr plan cat PLAN_ID                       # Output the JSON representation of a scheduled plan to the screen or a file
  gzr plan disable PLAN_ID                   # Disable the specified plan
  gzr plan enable PLAN_ID                    # Enable the specified plan
  gzr plan failures                          # Report all plans that failed in their most recent run attempt
  gzr plan help [COMMAND]                    # Describe subcommands or one specific subcommand
  gzr plan import PLAN_FILE OBJ_TYPE OBJ_ID  # Import a plan from a file
  gzr plan ls                                # List the scheduled plans on a server
  gzr plan rm PLAN_ID                        # Delete a scheduled plan
  gzr plan runit PLAN_ID                     # Execute a saved plan immediately

    OUT

    expect(output).to eq(expected_output)
  end
end
