#
# GuardState: chef_vault_try_notify
# Copyright (c) 2015 Nordstrom, Inc.
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
