module Pushr
  class ConfigurationFcm < Pushr::Configuration
    attr_accessor :api
    validates :api, presence: true

    def name
      :fcm
    end

    def to_hash
      { type: self.class.to_s, app: app, enabled: enabled, connections: connections, api: api }
    end
  end
end
