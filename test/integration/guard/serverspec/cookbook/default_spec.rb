#
# Copyright (c) 2015 Nordstrom, Inc.
#

require 'spec_helper'

describe file('/tmp/secrets_ok') do
  it { should be_file }
end
