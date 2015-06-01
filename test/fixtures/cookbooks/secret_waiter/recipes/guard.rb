include_recipe 'chef_vault_try_notify'

chef_vault_try_notify 'my_secrets' do
  vault_items %w(foo/bar baz/wibble)
  guard true
end

file '/tmp/secrets_ok' do
  only_if { vault_available?('my_secrets') }
end

file '/tmp/secrets_failure' do
  not_if { vault_available?('my_secrets') }
end
