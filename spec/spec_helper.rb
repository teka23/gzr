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

require "bundler/setup"
require "gzr"

module Gzr
  class CLI
    Error = Class.new(StandardError)
  end
end

class HashResponse
  def initialize(doc)
    @doc = doc
  end

  def to_attrs
    @doc
  end

  def respond_to?(m, include_private = false)
    m = m.to_sym if m.instance_of? String
    @doc.respond_to?(m) || @doc.has_key?(m)
  end

  def method_missing(m, *args, &block)
    m = m.to_sym if m.instance_of? String
    if @doc.respond_to?(m)
      @doc.send(m, *args, &block)
    else
      @doc.fetch(m,nil)
    end
  end
end


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
