module Pushr
  class ConfigurationFcm < Pushr::Configuration
    attr_accessor :service_account, :project_id
    validates :service_account, presence: true
    validates :project_id, presence: true

    def name
      :fcm
    end

    def to_hash
      { type: self.class.to_s, app: app, enabled: enabled, connections: connections, service_account: service_account,
        project_id: project_id }
    end
  end
end
