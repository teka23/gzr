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

RSpec.describe "`gzr attribute` command", type: :cli do
  it "executes `gzr help attribute` command successfully" do
    output = `gzr help attribute`
    expected_output = <<-OUT
Commands:
  gzr attribute cat ATTR_ID|ATTR_NAME                                        # Output json information about an attribute to screen or file
  gzr attribute create ATTR_NAME [ATTR_LABEL] [OPTIONS]                      # Create or modify an attribute
  gzr attribute get_group_value GROUP_ID|GROUP_NAME ATTR_ID|ATTR_NAME        # Retrieve a user attribute value for a group
  gzr attribute help [COMMAND]                                               # Describe subcommands or one specific subcommand
  gzr attribute import FILE                                                  # Import a user attribute from a file
  gzr attribute ls                                                           # List all the defined user attributes
  gzr attribute rm ATTR_ID|ATTR_NAME                                         # Delete a user attribute
  gzr attribute set_group_value GROUP_ID|GROUP_NAME ATTR_ID|ATTR_NAME VALUE  # Set a user attribute value for a group

    OUT

    expect(output).to eq(expected_output)
  end
end
