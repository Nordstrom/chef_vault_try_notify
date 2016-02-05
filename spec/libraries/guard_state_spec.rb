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
