#
# Provider: chef_vault_try_notify
# Copyright (c) 2015 Nordstrom, Inc.
#

require 'ostruct'

include ChefVaultItem

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
        end
      end
      if state.failed_vault_items.empty?
        ::ChefVaultTryNotify::GuardState.instance.ok[new_resource.name] = true
        done = true
      else
        # if guard is true, we return on failure - the lack of an entry
        # in the GuardState singleton is used later
        return if new_resource.guard
        Chef::Log.warn 'could not decrypt secrets for vault items ' \
          "#{state.failed_vault_items.join(',')}"
        state.waiting_for = (Time.now - start_time).to_i
        new_resource.on_failure.call(state)
        sleep new_resource.wait_period
      end
    end
  end
end
