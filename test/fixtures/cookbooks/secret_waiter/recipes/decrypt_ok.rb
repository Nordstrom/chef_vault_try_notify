include_recipe 'chef_vault_try_notify'

chef_vault_try_notify 'my_secrets' do
  vault_items %w(foo/bar baz/wibble)
  on_failure do |state|
    Chef::Log.warn "could not decrypt secrets after #{state.tries} tries"
  end
end
