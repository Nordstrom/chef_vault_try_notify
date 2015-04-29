require 'aws-sdk'
require 'ostruct'

require_relative '../../libraries/helper'

class TestSnsHelper
  include ChefVaultTryNotify::Helper
end

RSpec.describe ChefVaultTryNotify::Helper do
  def fake_node
    node = double 'chef node'
    allow(node).to receive(:[]).with('fqdn').and_return('foobar.example.com')
    allow(node).to receive(:[]).with('ipaddress').and_return('10.10.10.10')
    allow(node).to receive(:[]).with('ip6address').and_return('fe80::4de:e7ff:fed4:1920')
    allow(node).to receive(:[]).with('macaddress').and_return('06:DE:E7:D4:19:20')
    allow(node).to receive(:[]).with('ec2').and_return(
      'instance_id' => 'i-deadbeef',
      'placement_availability_zone' => 'us-west-2a'
    )
    allow(node).to receive(:chef_environment).and_return('myapp-prod')
    node
  end

  def fake_state
    OpenStruct.new(
      tries: 5,
      max_tries: 30,
      wait_period: 10,
      waiting_for: 70,
      vault_items: ['foo/bar']
    )
  end

  describe 'inclusion' do
    it 'should provide the sns_notify method' do
      expect(TestSnsHelper.instance_methods).to include :sns_notify
    end
  end

  describe '#sns_notify' do
    it 'should notify the SNS topic' do
      node = fake_node
      state = fake_state
      client = double 'sns client'
      expect(Aws::SNS::Client)
        .to receive(:new)
        .with(hash_including(region: 'us-west-2'))
        .and_return(client)
      expect(client)
        .to receive(:publish)
        .with(Hash)
        .and_return(message_id: 'a-b-c-d-e')
      expect(Chef::Log).to receive(:info).with(/notified arn:aws:sns:us-east-1:12345:MyTopic-ABCDE with message id a-b-c-d-e/)
      TestSnsHelper.new.sns_notify(
        node, state,
        region: 'us-west-2',
        topic: 'arn:aws:sns:us-east-1:12345:MyTopic-ABCDE'
      )
    end

    it 'should log if publishing fails' do
      node = fake_node
      state = fake_state
      client = double 'sns client'
      expect(Aws::SNS::Client).to receive(:new).with(Hash).and_return(client)
      expect(client)
        .to receive(:publish)
        .with(Hash)
        .and_raise(Aws::SNS::Errors::ServiceError.new(1, 2))
      expect(Chef::Log).to receive(:warn).with(/unable to send SNS notification/)
      TestSnsHelper.new.sns_notify(
        node, state,
        region: 'us-west-2',
        topic: 'arn:aws:sns:us-east-1:12345:MyTopic-ABCDE'
      )
    end

    it 'should extract the region from Ohai data if not provided' do
      node = fake_node
      state = fake_state
      client = double 'sns client'
      expect(Aws::SNS::Client)
        .to receive(:new)
        .with(hash_including(region: 'us-west-2'))
        .and_return(client)
      expect(client)
        .to receive(:publish)
        .with(Hash)
        .and_return(message_id: 'a-b-c-d-e')
      TestSnsHelper.new.sns_notify(
        node, state,
        topic: 'arn:aws:sns:us-east-1:12345:MyTopic-ABCDE'
      )
    end
  end
end
