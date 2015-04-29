RSpec.describe 'chef_vault_try_notify::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'converges successfully' do
    expect(chef_run).to include_recipe(described_recipe)
  end

  it 'include the chef-vault recipe' do
    expect(chef_run).to include_recipe('chef-vault::default')
  end
end
