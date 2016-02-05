include_recipe 'chef_vault_try_notify'

chef_vault_try_notify 'my_secrets' do
  vault_items %w(passwords_data_bag/admin_data_bag_item)
  max_tries 2
  wait_period 1
  on_failure do |state|
    Chef::Log.warn "this is where we would send an SNS notification after #{state.tries} tries"
  end
end
