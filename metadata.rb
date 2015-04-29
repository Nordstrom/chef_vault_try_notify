#
# Copyright (c) 2015 Nordstrom, Inc.
#
# Originally created from Nordstrom Cookbook Template v0.16.2
#

name             'chef_vault_try_notify'
maintainer       'Nordstrom, Inc.'
maintainer_email 'techcheftm@nordstrom.com'
license          'MIT'
description      "attempt to decrypt a chef-vault secret and notify if you can't"
version          '0.1.0'

depends          'chef-vault', '~> 1.3'
