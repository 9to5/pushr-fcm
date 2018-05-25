require 'spec_helper'
require 'pushr/daemon/fcm'
require 'pushr/daemon/fcm_support/connection_fcm'

describe Pushr::Daemon::Fcm do
  let(:fcm) { Pushr::Daemon::Fcm.new(test: 'test') }

  describe 'responds to' do
    it 'configuration' do
      expect(fcm.configuration).to eql(test: 'test')
    end
  end
end
