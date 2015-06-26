include_recipe 'chef_vault_try_notify'

chef_vault_try_notify 'my_secrets' do
  vault_items %w(foo/bar baz/wibble)
  guard true
end
