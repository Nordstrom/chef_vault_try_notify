RSpec.describe 'secret_waiter::decrypt_ok' do
  include ChefVault::TestFixtures.rspec_shared_context

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: %w(chef_vault_try_notify)
    ).converge(described_recipe)
  end

  it 'does not call the on_failure block if the secrets can be decrypted' do
    expect(chef_run).to test_chef_vault_secrets('my_secrets')
    expect(Chef::Log).not_to receive(:warn).with(/could not decrypt secrets/)
  end
end
