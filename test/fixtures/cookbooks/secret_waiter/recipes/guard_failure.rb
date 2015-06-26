include_recipe 'chef_vault_try_notify'

chef_vault_try_notify 'my_secrets' do
  vault_items %w(foo/bar baz/wibble)
  test_and_remember true
end

chef_vault_try_notify 'my_other_secrets' do
  vault_items %w(foo/other_bar baz/other_wibble)
  test_and_remember true
end

file '/tmp/secrets_ok' do
  only_if { vault_available?('my_secrets') }
end

file '/tmp/secrets_failure' do
  only_if { vault_available?('my_other_secrets') }
end
