module Pushr
  module Daemon
    module FcmSupport
      class JsonReader
        def initialize(configuration)
          @configuration = configuration
        end

        def read
          @configuration.service_account
        end
      end

      class Authenticator
        attr_reader :configuration
        SCOPE = 'https://www.googleapis.com/auth/firebase.messaging'.freeze

        def initialize(configuration, i)
          @configuration = configuration
          @name = "#{@configuration.app}: AuthenticatorFcm #{i}"
        end

        def fetch_access_token
          if @response.nil? || (@request_at + @response['expires_in'] < Time.now)
            Pushr::Daemon.logger.info("[#{@name}] Refresh access token")
            authorizer = fetch_credentials
            @request_at = Time.now
            @response = authorizer.fetch_access_token!
          end
          puts @response['access_token'].inspect
          @response['access_token']
        end

        private

        def fetch_credentials
          ::Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: JsonReader.new(@configuration), scope: SCOPE)
          # authorizer = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('/Users/tom/Downloads/api-7505019477374111882-459984-firebase-adminsdk-o569m-8d9bc31fb7.json'), scope: scope)
        end
      end
    end
  end
end
