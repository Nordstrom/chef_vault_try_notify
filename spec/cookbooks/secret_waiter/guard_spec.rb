RSpec.describe 'secret_waiter::guard' do
  include ChefVault::TestFixtures.rspec_shared_context

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: %w(chef_vault_try_notify)
    ).converge(described_recipe)
  end

  it 'creates a file only if the secrets are available' do
    expect(chef_run).to render_file('/tmp/secrets_ok')
  end

  it 'does not create a file if the secrets are available' do
    expect(chef_run).not_to render_file('/tmp/secrets_failure')
  end
end
