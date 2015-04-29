#
# ChefSpec Matchers: chef_vault_try_notify
# Copyright (c) 2015 Nordstrom, Inc.
#

if defined?(ChefSpec)
  # not the standard name, which would be test_secrets_chef_vault_try_notify.  Ugh.
  def test_chef_vault_secrets(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_vault_try_notify, :test_secrets, resource_name)
  end
end
