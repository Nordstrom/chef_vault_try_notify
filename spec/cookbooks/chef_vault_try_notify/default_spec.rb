# Copyright 2015 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
