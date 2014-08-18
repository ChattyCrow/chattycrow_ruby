module ChattyCrow
  module Request
    class BaseRequest
      # Methods
      attr_accessor :recipients, :payload, :channel

      # Intiialize
      def initialize(options = {})
        # Recipients
        @recipients = ChattyCrow.wrap(options.delete(:recipients)).compact

        # Channel
        @channel = options.delete(:channel)
      end

      def headers
         ChattyCrow.default_headers(@channel)
      end

      def payload
        @payload
      end

      def to_json
        { recipients: @recipients, payload: payload, headers: headers }
      end
    end
  end
end
