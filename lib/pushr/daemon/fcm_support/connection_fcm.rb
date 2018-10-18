module Pushr
  module Daemon
    module FcmSupport
      class ConnectionError < StandardError; end

      class ConnectionFcm
        attr_reader :response, :name, :configuration, :authenticator, :url
        IDLE_PERIOD = 5 * 60

        def initialize(configuration, i)
          @configuration = configuration
          @name = "#{@configuration.app}: ConnectionFcm #{i}"
          @authenticator = Pushr::Daemon::FcmSupport::Authenticator.new(configuration, i)
          @url = "https://fcm.googleapis.com/v1/projects/#{configuration.project_id}/messages:send"
        end

        def connect
          @last_use = Time.now
          uri = URI.parse(@url)
          @connection = open_http(uri.host, uri.port)
          @connection.start
          Pushr::Daemon.logger.info("[#{@name}] Connected to #{@url}")
        end

        def write(data)
          retry_count = 0
          begin
            response = notification_request(data.to_message)
            handler = Pushr::Daemon::FcmSupport::ResponseHandler.new(response, data, retry_count)
            handler.handle
          rescue => e
            retry_count += 1
            if retry_count < 10
              retry
            else
              raise e
            end
          end
        end

        private

        def open_http(host, port)
          http = Net::HTTP.new(host, port)
          http.use_ssl = true
          http
        end

        def notification_request(data)
          headers = { 'Authorization' => "Bearer #{@authenticator.fetch_access_token}",
                      'Content-type' => 'application/json' }
          uri = URI.parse(@url)
          post(uri, data, headers)
        end

        def post(uri, data, headers)
          reconnect_idle if idle_period_exceeded?

          retry_count = 0

          begin
            response = @connection.post(uri.path, data, headers)
            @last_use = Time.now
          rescue EOFError, Errno::ECONNRESET, Timeout::Error => e
            retry_count += 1

            Pushr::Daemon.logger.error("[#{@name}] Lost connection to #{@url} (#{e.class.name}), reconnecting ##{retry_count}...")

            if retry_count <= 3
              reconnect
              sleep 1
              retry
            else
              raise ConnectionError, "#{@name} tried #{retry_count - 1} times to reconnect but failed (#{e.class.name})."
            end
          end

          response
        end

        def idle_period_exceeded?
          # Timeout on the http connection is 5 minutes, reconnect after 5 minutes
          @last_use + IDLE_PERIOD < Time.now
        end

        def reconnect_idle
          Pushr::Daemon.logger.info("[#{@name}] Idle period exceeded, reconnecting...")
          reconnect
        end

        def reconnect
          @connection.finish
          @last_use = Time.now
          @connection.start
        end
      end
    end
  end
end
