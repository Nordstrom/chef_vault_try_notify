include_recipe 'chef_vault_try_notify'

chef_vault_try_notify 'my_secrets' do
  vault_items %w(foo/bar baz/wibble)
  test_and_remember true
end

file '/tmp/secrets_ok' if vault_available?('my_secrets')

file '/tmp/secrets_failure' unless vault_available?('my_secrets')
