#
# Helpers: chef_vault_try_notify
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

require 'json'

module ChefVaultTryNotify
  # helpers for the chef_vault_try_notify resource
  module Helper
    # sends an SNS notification when a vault item cannot be decrypted
    # @param node [Chef::Node] the chef node object
    # @param state [Struct] the state of the attempt to decrypt the vault items
    # @param opts [Hash] options
    # @option opts [String] :topic the SNS topic
    # @option opts [String] :region the AWS region.  Defaults to the value from Ohai data
    # @option opts [String] :credentials the AWS credentials to use
    # @return [void]
    def sns_notify(node, state, opts)
      require 'aws-sdk'
      begin
        opts[:region] ||= az_from_placement(node['ec2']['placement_availability_zone'])
        args = { region: opts[:region] }
        args[:credentials] = opts[:credentials] if opts.key?(:credentials)
        client = Aws::SNS::Client.new(args)
        resp = client.publish(
          topic_arn: opts[:topic],
          message: notification_json(node, state)
        )
        Chef::Log.info "notified #{opts[:topic]} with message id #{resp[:message_id]}"
      rescue Aws::SNS::Errors::ServiceError => e
        Chef::Log.warn "unable to send SNS notification: #{e}"
      end
    end

    private

    def az_from_placement(placement)
      placement.chop
    end

    def notification_json(node, state)
      {
        type: 'chef_vault_try_notify_failure',
        tries: state.tries,
        fqdn: node['fqdn'],
        instance_id: node['ec2']['instance_id'],
        ipaddress: node['ipaddress'],
        ip6address: node['ip6address'],
        macaddress: node['macaddress'],
        chef_environment: node.chef_environment,
        max_tries: state.max_tries,
        wait_period: state.wait_period,
        waiting_for: state.waiting_for,
        failed_vault_items: state.failed_vault_items
      }.to_json
    end
  end

  # helpers for the vault_available? guard
  module GuardHelper
    # a guard that succeeds if the vault can be decrypted
    # @param set [String] the secret name previously used to name
    #   a chef_vault_try_notify resource
    # @return [Boolean] whether the secrets are available
    def vault_available?(set)
      ChefVaultTryNotify::GuardState.instance.ok.key?(set)
    end
  end
end
