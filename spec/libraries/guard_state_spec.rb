require_relative '../../libraries/guard_state'

RSpec.describe ChefVaultTryNotify::GuardState do
  it 'should only have one instance' do
    gs1 = ChefVaultTryNotify::GuardState.instance
    gs2 = ChefVaultTryNotify::GuardState.instance
    expect(gs1).to be(gs2)
  end

  it 'should provide an .ok reader' do
    ok = ChefVaultTryNotify::GuardState.instance.ok
    expect(ok).to be_a Hash
  end
end
