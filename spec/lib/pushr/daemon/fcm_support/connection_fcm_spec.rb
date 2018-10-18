require 'spec_helper'
require 'pushr/daemon'
require 'pushr/fcm'
require 'pushr/daemon/logger'
require 'pushr/message_fcm'
require 'pushr/configuration_fcm'
require 'pushr/daemon/delivery_error'

describe Pushr::Daemon::FcmSupport::ConnectionFcm do
  before(:each) do
    Pushr::Core.configure do |config|
      config.redis = ConnectionPool.new(size: 1, timeout: 1) { MockRedis.new }
    end

    class_double('Pushr::Daemon::FcmSupport::Authenticator',
                 new: instance_double('Pushr::Daemon::FcmSupport::Authenticator',
                                      fetch_access_token: 'mock_access_token')).as_stubbed_const

    logger = double('logger')
    allow(logger).to receive(:info)
    allow(logger).to receive(:error)
    allow(logger).to receive(:warn)
    Pushr::Daemon.logger = logger
  end

  let(:config) do
    Pushr::ConfigurationFcm.new(app: 'app_name', connections: 2, enabled: true, project_id: 'project_id',
                                service_account: '{}')
  end
  let(:connection) { Pushr::Daemon::FcmSupport::ConnectionFcm.new(config, 1) }

  describe 'sends a message to topic' do
    let(:message) do
      hsh = { app: 'app_name', topic: 'test' }
      Pushr::MessageFcm.new(hsh)
    end

    it 'succesful', :vcr do
      connection.connect
      connection.write(message)
      # TODO: expect(connection.write(message).code).to eql '200'
    end

    # it 'fails and should Retry-After', :vcr do
    #   expect_any_instance_of(Pushr::Daemon::FcmSupport::ConnectionFcm).to receive(:sleep)
    #   connection.connect
    #   connection.write(message)
    # end
    #
    # it 'fails and should Retry-After with date', :vcr do
    #   expect_any_instance_of(Pushr::Daemon::FcmSupport::ConnectionFcm).to receive(:sleep)
    #   connection.connect
    #   connection.write(message)
    # end
    #
    # it 'fails and should sleep after fail', :vcr do
    #   expect_any_instance_of(Pushr::Daemon::FcmSupport::ConnectionFcm).to receive(:sleep)
    #   connection.connect
    #   connection.write(message)
    # end
    #
    # it 'fails of a json formatting execption', :vcr do
    #   connection.connect
    #   connection.write(message)
    #   # TODO: assert
    # end
    #
    # it 'fails of a not authenticated execption', :vcr do
    #   connection.connect
    #   connection.write(message)
    #   # TODO: assert
    # end
  end

  describe 'sends a message to token' do
    let(:message) do
      hsh = { app: 'app_name', token: 'token', notification: { title: 'test', body: 'message' } }
      Pushr::MessageFcm.new(hsh)
    end

    it 'succesful', :vcr do
      connection.connect
      connection.write(message)
      # TODO: expect(connection.write(message).code).to eql '200'
    end
  end

  describe 'sends a message to condition' do
    let(:message) do
      hsh = { app: 'app_name', condition: "'foo' in topics && 'bar' in topics'" }
      Pushr::MessageFcm.new(hsh)
    end

    it 'succesful', :vcr do
      connection.connect
      connection.write(message)
      # TODO: expect(connection.write(message).code).to eql '200'
    end
  end
end
