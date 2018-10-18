module Pushr
  module Daemon
    module FcmSupport
      class ResponseHandler
        attr_accessor :response, :data, :retry_count
        def initialize(response, data, retry_count)
          @response = response
          @data = data
          @retry_count = retry_count
        end

        def handle
          case @response.code.to_i
          when 200
            handle_success_response
          when 400
            # Pushr::Daemon.logger.error("[#{@name}] JSON formatting exception received.")
            Pushr::Daemon::DeliveryError.new(@response.code, @data, 'JSON formatting exception', 'FCM', false)
          when 401
            # Pushr::Daemon.logger.error("[#{@name}] Authentication exception received.")
            Pushr::Daemon::DeliveryError.new(@response.code, @data, 'Authentication exception', 'FCM', false)
          when 500..599
            # internal error FCM server || service unavailable: exponential back-off
            handle_error_5xx_response()
          else
            # Pushr::Daemon.logger.error("[#{@name}] Unknown error: #{@response.code} #{response.message}")
            Pushr::Daemon::DeliveryError.new(@response.code, @data, "Unknown error: #{response.message}", 'FCM', false)
          end
        end

        # sleep if there is a Retry-After header
        def handle_error_5xx_response
          value = @response.header['Retry-After']
          if value && value.to_i.positive?
            sleep value.to_i # Retry-After: 3600
          elsif value && Date.rfc2822(value) # Retry-After: Fri, 31 Dec 1999 23:59:59 GMT
            sleep Time.now.utc - Date.rfc2822(value).to_time.utc
          else
            sleep 2**@retry_count
          end
        end

        def handle_success_response()
          puts @response.body.inspect
        end
      end
    end
  end
end
