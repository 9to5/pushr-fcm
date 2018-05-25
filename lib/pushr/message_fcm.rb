module Pushr
  class MessageFcm < Pushr::Message
    POSTFIX = 'fcm'.freeze

    attr_accessor :to, :registration_ids, :collapse_key, :priority, :content_available, :mutable_content, :time_to_live,
                  :restricted_package_name, :dry_run, :data, :notification

    validates :registration_ids, presence: true, unless: ->(message) { message.to.present? }
    validate :registration_ids_array, unless: ->(message) { message.to.present? }
    validates :to, presence: true, unless: ->(message) { message.registration_ids.present? }
    validate :data_size
    validates :time_to_live, numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                             less_than_or_equal_to: 2419200 },
                             allow_blank: true

    def to_message
      hsh = {}
      %w[to registration_ids collapse_key priority content_available mutable_content time_to_live
         restricted_package_name dry_run data notification].each do |variable|
        hsh[variable] = send(variable) if send(variable)
      end
      MultiJson.dump(hsh)
    end

    def to_hash
      hsh = { type: self.class.to_s, app: app, to: to, registration_ids: registration_ids, collapse_key: collapse_key,
              priority: priority, content_available: content_available, mutable_content: mutable_content,
              time_to_live: time_to_live, restricted_package_name: restricted_package_name, dry_run: dry_run,
              data: data, notification: notification }
      hsh[Pushr::Core.external_id_tag] = external_id if external_id
      hsh
    end

    private

    def registration_ids_array
      if registration_ids.class != Array
        errors.add(:registration_ids, 'is not an array')
      elsif registration_ids.size > 1000
        errors.add(:registration_ids, 'is too big (max 1000)')
      elsif registration_ids.size.zero?
        errors.add(:registration_ids, 'is too small (min 1)')
      end
    end

    def data_size
      errors.add(:data, 'is more thank 4kb') if data && MultiJson.dump(data).bytes.count > 4096
    end
  end
end
