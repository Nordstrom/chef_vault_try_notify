# Revision History for chef_vault_try_notify

## 0.4.0

* replace 'include ChefVaultItem' with 'include ChefVaultCookbook' to reflect
change in chef-vault cookbook 1.3.1
* fix specs
* Switch from MIT to Apache 2.0 license

## 0.3.0

* fix the predicate use of the guard state helper (it could throw a LocalJumpError exception previously)
* change the name of the `guard` attribute of the resource to `test_and_remember`.  `guard` remains usable as an alias and will for the next few releases, but issues a deprecation warning

## 0.2.1

* fix the exception catching block in the SNS handler to ensure that aws-sdk is loaded before we try to catch one of its exceptions

## 0.2.0

* add a `guard` mode to the resource, which tries to decrypt one and remembers the result for use later in a `vault_available?` guard

## 0.1.0

* initial release to public supermarket
