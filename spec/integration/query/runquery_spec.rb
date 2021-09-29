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

RSpec.describe "`gzr query runquery` command", type: :cli do
  it "executes `gzr query help runquery` command successfully" do
    output = `gzr query help runquery`
    expected_output = <<-OUT
Usage:
  gzr query runquery QUERY_DEF

Options:
  -h, [--help], [--no-help]  # Display usage information
      [--file=FILE]          # Filename for saved data
      [--format=FORMAT]      # One of json,json_detail,csv,txt,html,md,xlsx,sql,png,jpg
                             # Default: json

Run query_id, query_slug, or json_query_desc
    OUT

    expect(output).to eq(expected_output)
  end
end
