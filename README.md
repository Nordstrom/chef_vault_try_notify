# chef_vault_try_notify

## Description

The chef_vault_try_notify cookbook provides a resource that can test if
the chef-vault secrets your cookbook needs are available.  If the vault
items can be decrypted, the resource takes no action.  If the secrets
cannot be decrypted (perhaps because this is an autoscaled node and the
vault has not yet been refreshed), the resource calls a ruby block which
can take whatever action is appropriate to get the secrets encrypted.

## Use Case

When using chef-vault secrets in cookbooks that converge nodes created
in an orchestration template or spawned from an autoscaling group, the
secrets will not be encrypted for the new node.  The secrets cannot be
encrypted until the node has registered with your Chef server and the
public key for the node is available.

The standard method of refreshing vault items for a new node is to run
`knife vault refresh`, a command intended for use by an operator, not
a program.

Members of the community have found ways around this problem, which tend
to fall into three categories:

1. Bootstrap the node with a runlist that does not require chef-vault
secrets, then have an operator refresh the vault items and change the run
list

2. Have the cookbook test for the availability of vault secrets and either
crash out or only converge resources that do not require secrets.  At
some point, a vault item refresh need to be performed in order to converge
all resources successfully.

3. Automatically refresh vault items using some automated mechanism, either
via cron or in response to a chef-client run failing.  This requires that
the automated mechanism have access to a private key for a Chef API user
that can write to the chef-vault encrypted data bag.

The resource provided by this cookbook adapts the second approach and sets
the groundwork for a more secure version of the third approach.

## Usage

To your cookbook's metadata.rb, add this line:

    depends 'chef_vault_try_notify', '~> 0.1'

This cookbook also requires that you use the `chef_vault_item` helper
from the [chef-vault cookbook](https://supermarket.chef.io/cookbooks/chef-vault)
instead of calling `ChefVault::Item.load` directly.  This ensures that
vault access happens at converge time rather than compile time.  This
cookbook depends on `chef-vault`, so you do not need to include it yourself.

Then add this line to any recipe that requires chef-vault secrets:

    include_recipe 'chef_vault_try_notify'

Prior to using a chef-vault secret, declare a resource to test if the secrets
are available:

    chef_vault_try_notify 'web server secrets' do
      vault_items ssl: %w(foo bar), password: %w(baz wibble)
      on_failure do |state|
        extend ChefVaultTryNotify::Helper
        sns_notify(
          node, state,
          topic: 'arn:aws:sns:us-east-1:12345:MyTopic-ABCDE'
        )
      end
    end

This resource will attempt to decrypt the vault items `bar` in the `foo` vault
and `wibble` in the `baz` vault.  If they can be decrypted, it takes no further
action.

If either secret cannot be decrypted, the `on_failure` block is called with a state
object describing the attempted decryption (number of tries so far, etc.).  In the
example above, the helper function `sns_notify` is used to send an AWS SNS notification
to a topic.

The resource will then retry the decryption, by default waiting for 10 seconds
and retrying up to 30 times.  Each time the decryption fails, the `on_failure`
block will be called again with an updated state Struct.

If the secrets cannot be decrypted after a defined number of attempts, the resource
will call `Chef::Application.fatal!` to end the Chef run.

The intent is that the notification will trigger some process to refresh the vault
items, and that the subsequent attempts to decrypt will be successful.

Nordstrom is developing an open-source tool to perform this refresh for nodes in
the AWS infrastructure, but this is a separate tool.  When it is available, this
cookbook will be updated to link to it.  For now, you can develop a bespoke tool
to perform the same task, or put a manual process behind the notification (an email
to an operator).  If the refresh process is human-driven, you will probably want to
change the wait period and timeout to avoid getting 30 emails every time an node is
autoscaled.

## Recipes

### default

The default recipe just includes the `chef-vault::default` recipe, which
installs the `chef-vault` gem.

## Attributes

There are no attributes defined by this cookbook.

## Resources

### chef_vault_try_notify

This resource tests if it can decrypt a set of vault items, and calls a ruby block
if it cannot.

#### Ruby Block Context

The `on_failure` ruby block is passed a state object that describes the attempt to
decrypt the vault items.  The available methods are:

* vault_items: a hash of the secrets which cannot be decrypted (structured the same as the `vault_items` attribute)
* tries: the number of times decryption has been attempted unsuccessfully
* max_tries: the maximum number of times decryption will be attempted before the resource fails
* wait_period: how long (in seconds) the resource waits between attempts to decrypt
* waiting_for: how long (in seconds) the resource has been waiting trying to decrypt the vault items

## Helpers

This cookbook provides a helper for sending a notification to an AWS SNS topic
when it cannot decrypt secrets.

These helpers are in the module ChefVaultTryNotify::Helper, which can be included
into your recipe or extended into the ruby block (as in the example above).

### sns_notify

`sns_notify` sends a notification to an AWS SNS topic.  It takes as arguments the
Chef node object, the state object passed to the `on_failure` ruby block, and a hash
of options.  The hash must have the following keys:

* topic: the ARN of the SNS topic

and can have the following keys:

* region: the AWS region to connect to
* credentials: the AWS credentials to use

If the region is not provided, it is constructed from EC2 Ohai data by taking the
value of `node['ec2']['placement_availability_zone']` and chopping off the last
character.

If the credentials are not provided, then the standard AWS SDK for Ruby rules apply,
which allow you to use IAM Instance Profiles.  Describing these in detail is beyond
the scope of this README, so please refer to the [AWS documentation](http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html).

To use `sns_notify`, you should also depend on the [aws cookbook](https://supermarket.chef.io/cookbooks/aws)
and include the `aws` recipe somewhere in order to install the `aws-sdk` gem.

The notification send to the topic is a JSON document similar to this:

```
{
  "type": "chef_vault_try_notify_failure",
  "tries": 1,
  "fqdn": "foobar.example.com",
  "instance_id": "i-DEADBEEF",
  "ipaddress": "10.10.10.10",
  "ip6address": "fe80::4de:e7ff:fed4:1920",
  "macaddress": "06:DE:E7:D4:19:20",
  "chef_environment": "application1-prod",
  "max_tries": 30,
  "wait_period": 10,
  "waiting_for": 30,
  "vault_items": {
    "ssl": ["foo", "bar"],
    "password": ["baz", "wibble"]
  }
}
```

This is hopefully enough information for whatever receives the notification to
authenticate the request and decide whether it should refresh the vault or not.

## Future Enhancements

PRs to provide support for other notification services, especially those of other
cloud providers are welcome.

## Author

Nordstrom, Inc.

## License

Copyright (c) 2015 Nordstrom, Inc., All Rights Reserved.

## Template Version

Originally created from Nordstrom Cookbook Template v0.16.2
