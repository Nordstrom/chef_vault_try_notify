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
RSpec.describe 'secret_waiter::decrypt_failure' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      step_into: %w(chef_vault_try_notify)
    ).converge(described_recipe)
  end

  it 'calls the on_failure block if passwords_data_bag/admin_data_bag_item cannot be decrypted' do
    allow(ChefVault::Item)
      .to receive(:vault?)
      .with('passwords_data_bag', 'admin_data_bag_item')
      .and_return(true)

    allow(ChefVault::Item)
      .to receive(:load)
      .with('passwords_data_bag', 'admin_data_bag_item')
      .and_raise(ChefVault::Exceptions::SecretDecryption)

    expect(Chef::Log)
      .to receive(:warn)
      .twice # because we're retrying 2x, each failure gets a chance to notify
      .with(/this is where we would send an SNS notification/)
    expect(Chef::Log)
      .to receive(:warn)
      .twice
      .with(/could not decrypt secrets/)
    expect { chef_run }
      .to raise_error(RuntimeError, /unable to decrypt secrets.+after 2 attempts/)
  end
end
