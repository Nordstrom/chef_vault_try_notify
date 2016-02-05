#
# Provider: chef_vault_try_notify
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

require 'ostruct'

include ChefVaultCookbook

provides :chef_vault_try_notify
use_inline_resources

def whyrun_supported?
  true
end

action :test_secrets do
  converge_by "try to decrypt vault items '#{new_resource.name}'" do
    start_time = Time.now
    state = OpenStruct.new(
      tries: 0,
      max_tries: new_resource.max_tries,
      wait_period: new_resource.wait_period
    )
    done = false
    until done
      state.tries += 1
      if state.tries > state.max_tries
        fail 'unable to decrypt secrets for vault items ' \
          "#{state.failed_vault_items.join(',')} after #{state.max_tries} attempts"
      end
      state.failed_vault_items = []
      new_resource.vault_items.each do |viname|
        begin
          bag, item = viname.split('/')
          chef_vault_item(bag, item)
        rescue ChefVault::Exceptions
          state.failed_vault_items.push viname
        # this code only supports a specific Test-Kitchen suite and
        # should never be encountered during normal use.  See the
        # commands in .kitchen.yml for more
        # rescue RuntimeError => e
        #   if e.message.match(/databag_fallback is disabled/)
        #     state.failed_vault_items.push viname
        #   else
        #     raise
        #   end
        end
      end
      if state.failed_vault_items.empty?
        ::ChefVaultTryNotify::GuardState.instance.ok[new_resource.name] = true
        done = true
      else
        # if guard is true, we're done
        if new_resource.test_and_remember
          done = true
        else
          Chef::Log.warn 'could not decrypt secrets for vault items ' \
            "#{state.failed_vault_items.join(',')}"
          state.waiting_for = (Time.now - start_time).to_i
          new_resource.on_failure.call(state)
          sleep new_resource.wait_period
        end
      end
    end
  end
end
