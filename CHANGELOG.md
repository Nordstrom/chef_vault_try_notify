# Revision History for chef_vault_try_notify

## 0.2.1

* fix the exception catching block in the SNS handler to ensure that aws-sdk is loaded before we try to catch one of its exceptions

## 0.2.0

* add a `guard` mode to the resource, which tries to decrypt one and remembers the result for use later in a `vault_available?` guard

## 0.1.0

* initial release to public supermarket
