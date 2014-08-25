module ChattyCrow
  module Request
    # Parent of all requests to ChattyCrow API
    class BaseRequest
      # Methods
      attr_accessor :contacts, :payload, :channel

      # Intialize (almost everwhere called by super)
      # @param options [Hash] options for request
      def initialize(options = {})
        # Recipients
        @contacts = ChattyCrow.wrap(options.delete(:contacts)).compact

        # Channel
        @channel = options.delete(:channel)
      end

      # Return chatty crow default headers for specific channel
      def headers
        ChattyCrow.default_headers(@channel)
      end

      # Get request for send
      # @return [Hash] Request
      def to_json
        { contacts: @contacts, payload: payload, headers: headers }
      end
    end
  end
end
