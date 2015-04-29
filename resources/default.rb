#
# Resource: chef_vault_try_notify
# Copyright (c) 2015 Nordstrom, Inc.
#

provides :chef_vault_try_notify

actions :test_secrets
default_action :test_secrets

attribute :name, :kind_of => String, :name_attribute => true
attribute :vault_items, :kind_of => Array, :required => true
attribute :max_tries, :kind_of => Fixnum, :default => 30
attribute :wait_period, :kind_of => Fixnum, :default => 10

def on_failure(arg = nil, &block)
  arg ||= block
  set_or_return(:on_failure, arg, :kind_of => Proc)
end
