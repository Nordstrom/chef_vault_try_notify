include_recipe 'chef_vault_try_notify'

chef_vault_try_notify 'my_secrets' do
  vault_items %w(foo/bar baz/gzonk)
  max_tries 2
  wait_period 1
  on_failure do |state|
    Chef::Log.warn "this is where we would send an SNS notification after #{state.tries} tries"
  end
end
