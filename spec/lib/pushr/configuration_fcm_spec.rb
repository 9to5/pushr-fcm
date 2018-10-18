require 'spec_helper'
require 'pushr/configuration_fcm'

describe Pushr::ConfigurationFcm do
  before(:each) do
    Pushr::Core.configure do |config|
      config.redis = ConnectionPool.new(size: 1, timeout: 1) { MockRedis.new }
    end
  end

  describe 'all' do
    it 'returns all configurations' do
      expect(Pushr::Configuration.all).to eql([])
    end
  end

  describe 'create' do
    it 'should create a configuration' do
      config = Pushr::ConfigurationFcm.new(app: 'app_name', connections: 2, enabled: true)
      expect(config.key).to eql('app_name:fcm')
    end
  end

  describe 'save' do
    let(:config) {
      Pushr::ConfigurationFcm.new(app: 'app_name', connections: 2, enabled: true, project_id: 'project_id',
                                  service_account: '{}')
    }
    it 'should save a configuration' do
      config.save
      expect(Pushr::Configuration.all.count).to eql(1)
      expect(Pushr::Configuration.all[0].class).to eql(Pushr::ConfigurationFcm)
    end
  end
end
