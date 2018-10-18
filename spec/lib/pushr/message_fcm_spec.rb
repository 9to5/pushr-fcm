require 'spec_helper'
require 'pushr/message_fcm'

describe Pushr::MessageFcm do
  before(:each) do
    Pushr::Core.configure do |config|
      config.redis = ConnectionPool.new(size: 1, timeout: 1) { MockRedis.new }
    end
  end

  describe 'next' do
    it 'returns next message' do
      expect(Pushr::Message.next('pushr:app_name:fcm')).to eql(nil)
    end
  end

  describe 'save' do
    let(:message) do
      hsh = { app: 'app_name', token: 'test' }
      Pushr::MessageFcm.new(hsh)
    end

    it 'should return true' do
      expect(message.save).to eql true
    end
    it 'should save a message' do
      message.save
      expect(Pushr::Message.next('pushr:app_name:fcm')).to be_kind_of(Pushr::MessageFcm)
    end
    it 'should respond to to_message' do
      expect(message.to_message).to be_kind_of(String)
    end
  end
end
