module ChattyCrow
  module Request
    class BaseRequest
      # Methods
      attr_accessor :contacts, :payload, :channel

      # Intiialize
      def initialize(options = {})
        # Recipients
        @contacts = ChattyCrow.wrap(options.delete(:contacts)).compact

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
        { contacts: @contacts, payload: payload, headers: headers }
      end
    end
  end
end
