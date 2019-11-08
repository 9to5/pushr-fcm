module Pushr
  class MessageFcm < Pushr::Message
    POSTFIX = 'fcm'.freeze

    attr_accessor :name, :data, :notification, :android, :webpush, :apns, :fcm_options, :token, :topic, :condition

    # {
    #   "name": string,
    #   "data": {
    #     string: string,
    #     ...
    #   },
    #   "notification": {
    #     object(Notification)
    #   },
    #   "android": {
    #     object(AndroidConfig)
    #   },
    #   "webpush": {
    #     object(WebpushConfig)
    #   },
    #   "apns": {
    #     object(ApnsConfig)
    #   },
    #   "fcm_options": {
    #     object (FcmOptions)
    #   },
    #
    #   // Union field target can be only one of the following:
    #   "token": string,
    #   "topic": string,
    #   "condition": string
    #   // End of list of possible types for union field target.
    # }

    def to_message
      hsh = {}
      %w[name data notification android webpush apns fcm_options token topic condition].each do |variable|
        hsh[variable] = send(variable) if send(variable)
      end
      MultiJson.dump(message: hsh)
    end

    def to_hash
      hsh = { type: self.class.to_s, app: app, name: name, data: data, notification: notification, android: android,
              webpush: webpush, apns: apns, fcm_options: fcm_options, token: token, topic: topic, condition: condition }
      hsh[Pushr::Core.external_id_tag] = external_id if external_id
      hsh
    end
  end
end
