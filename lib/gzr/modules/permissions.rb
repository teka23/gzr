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

# frozen_string_literal: true

module Gzr
  module Permissions

    def query_all_permissions()
      data = nil
      begin
        data = @sdk.all_permissions()
      rescue LookerSDK::Error => e
          say_error "Error querying all_permissions()"
          say_error e.message
          raise
      end
      data
    end

  end
end

