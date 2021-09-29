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

RUBY_VERSION = File.read(File.join(File.dirname(__FILE__), '.ruby-version')).split('-').last.chomp

ruby '2.5.8', engine: 'ruby', engine_version: RUBY_VERSION

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in gzr.gemspec
gemspec
#gem 'looker-sdk', :git => 'git@github.com:looker/looker-sdk-ruby.git'
#gem 'tty', :git => 'git@github.com:piotrmurach/tty.git'
#gem 'tty-file', :git => 'git@github.com:piotrmurach/tty-file.git'

