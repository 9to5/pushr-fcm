module Pushr
  class MessageFcm < Pushr::Message
    POSTFIX = 'fcm'.freeze

    attr_accessor :name, :data, :notification, :android, :webpush, :apns, :token, :topic, :condition


    def to_message
      hsh = {}
      %w[name data notification android webpush apns token topic condition].each do |variable|
        hsh[variable] = send(variable) if send(variable)
      end
      MultiJson.dump(message: hsh)
    end

    def to_hash
      hsh = { type: self.class.to_s, app: app, name: name, data: data, notification: notification, android: android,
              webpush: webpush, apns: apns, token: token, topic: topic, condition: condition }
      hsh[Pushr::Core.external_id_tag] = external_id if external_id
      hsh
    end
  end
end
