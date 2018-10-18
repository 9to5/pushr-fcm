require 'spec_helper'
require 'pushr/daemon'
require 'pushr/fcm'
require 'pushr/feedback_fcm'
require 'pushr/message_fcm'

describe Pushr::Daemon::FcmSupport::ResponseHandler do
  it 'should handle no errors' do
    json = '{"name": "projects/project_id/messages/9216177826578065331"}'
    response = double('response')
    allow(response).to receive(:body).and_return(json)
    allow(response).to receive(:code).and_return('200')

    message = double('message')
    handler = Pushr::Daemon::FcmSupport::ResponseHandler.new(response, message, 0)
    handler.handle
    # TODO: assert
  end
end
