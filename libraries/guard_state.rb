#
# GuardState: chef_vault_try_notify
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

require 'singleton'

module ChefVaultTryNotify
  # a singleton that remembers whether secrets secrets
  # could or could not be decrypted to facility
  class GuardState
    include Singleton

    attr_reader :ok

    def initialize
      @ok = {}
    end
  end
end
