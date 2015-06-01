RSpec.describe 'chef_vault_try_notify::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'converges successfully' do
    expect(chef_run).to include_recipe(described_recipe)
  end

  it 'include the chef-vault recipe' do
    expect(chef_run).to include_recipe('chef-vault::default')
  end

  it 'adds the vault_available? helper to recipes' do
    recipe = Chef::Recipe.new(
      'chef_vault_try_notify', 'default', chef_run.run_context
    )
    expect(recipe).to respond_to(:vault_available?)
  end
end
