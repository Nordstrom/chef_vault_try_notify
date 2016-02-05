#
# Resource: chef_vault_try_notify
# Copyright 2015 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides :chef_vault_try_notify

actions :test_secrets
default_action :test_secrets

attribute :name, :kind_of => String, :name_attribute => true
attribute :vault_items, :kind_of => Array, :required => true
attribute :max_tries, :kind_of => Fixnum, :default => 30
attribute :wait_period, :kind_of => Fixnum, :default => 10
attribute :test_and_remember, :kind_of => [TrueClass, FalseClass], :default => false

def on_failure(arg = nil, &block)
  arg ||= block
  set_or_return(:on_failure, arg, :kind_of => Proc)
end

def after_created
  run_action(:test_secrets)
end

def guard(v = nil)
  Chef::Log.warn "the 'guard' attribute of chef_vault_try_notify is deprecated, use 'test_and_remember' instead"
  test_and_remember(v)
end
