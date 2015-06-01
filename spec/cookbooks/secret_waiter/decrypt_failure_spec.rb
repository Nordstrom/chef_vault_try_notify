RSpec.describe 'secret_waiter::decrypt_failure' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: %w(chef_vault_try_notify)
    ).converge(described_recipe)
  end

  it 'calls the on_failure block if the secrets canot be decrypted' do
    bag = double 'data bag'
    %w(bar gzonk).each do |itemname|
      expect(bag).to receive(:key?)
        .at_least(:once)
        .with("#{itemname}_keys")
        .and_return(true)
      expect(bag)
        .to receive(:[])
        .with("#{itemname}_keys")
        .at_least(:once)
        .and_raise(ChefVault::Exceptions::SecretDecryption)
    end
    %w(foo baz).each do |bagname|
      expect(Chef::DataBag)
        .to receive(:load)
        .at_least(:once)
        .with(bagname)
        .and_return(bag)
    end
    expect(Chef::Log)
      .to receive(:warn)
      .at_least(:once)
      .with(/this is where we would send an SNS notification/)
    expect(Chef::Log)
      .to receive(:warn)
      .twice
      .with(/could not decrypt secrets/)
    expect { chef_run }
      .to raise_error(RuntimeError, /unable to decrypt secrets.+after 2 attempts/)
  end
end
