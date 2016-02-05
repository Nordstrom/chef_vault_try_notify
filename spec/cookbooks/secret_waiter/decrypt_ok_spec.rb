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
#
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
