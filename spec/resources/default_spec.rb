RSpec.describe 'secret_waiter::guard_deprecation' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'should emit a deprecation warning if the guard attribute is used' do
    expect(Chef::Log)
      .to receive(:warn)
      .with(/the 'guard' attribute of chef_vault_try_notify is deprecated/)
    chef_run
  end
end
