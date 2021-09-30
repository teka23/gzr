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

require 'gzr/commands/role/cat'

RSpec.describe Gzr::Commands::Role::Cat do
  it "executes `role cat` command successfully" do
    require 'sawyer'
    role_doc = <<-DOC
{
  "id": 100,
  "name": "Mock Role",
  "permission_set": {
    "id": 2,
    "name": "Developer",
    "permissions": [
      "access_data",
      "create_table_calculations",
      "deploy",
      "develop",
      "download_without_limit",
      "explore",
      "manage_spaces",
      "save_content",
      "schedule_look_emails",
      "see_lookml",
      "see_lookml_dashboards",
      "see_looks",
      "see_sql",
      "see_user_dashboards",
      "use_sql_runner"
    ],
    "built_in": false,
    "all_access": false,
    "url": "https://localhost:19999/api/3.0/permission_sets/2",
    "can": {
    }
  },
  "model_set": {
    "id": 80,
    "name": "mock_modelset",
    "models": [
      "mock_model"
    ],
    "built_in": false,
    "all_access": false,
    "url": "https://localhost:19999/api/3.0/model_sets/80",
    "can": {
    }
  },
  "url": "https://localhost:19999/api/3.0/roles/100",
  "users_url": "https://localhost:19999/api/3.0/roles/100/users",
  "can": {
    "show": true,
    "index": true,
    "update": true
  }
}
    DOC
    role_json = JSON.parse(role_doc)
    mock_role = double(Sawyer::Resource, role_json)
    allow(mock_role).to receive(:to_attrs).and_return(role_json)
    mock_sdk = Object.new
    allow(mock_sdk).to receive(:logout)
    allow(mock_sdk).to receive(:role) do |role_id,body|
      mock_role
    end
    output = StringIO.new
    options = {}
    command = Gzr::Commands::Role::Cat.new(100,options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq role_doc
  end
end
