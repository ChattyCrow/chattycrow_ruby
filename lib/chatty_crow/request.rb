module ChattyCrow
  module Request
    # Parent of all requests to ChattyCrow API
    class BaseRequest
      # Methods
      attr_accessor :contacts, :payload, :channel

      # Intialize options!
      attr_accessor :arguments, :options

      # Intialize (almost everwhere called by super)
      # @param args [Array] options for request
      def initialize(*args)
        # Error when attributes not exists!
        fail ::ArgumentError if args.empty?

        # Parse options and arguments
        # Arguments can be simple message!
        @options   = ChattyCrow.extract_options!(args)
        @arguments = args

        # Recipients
        @contacts = ChattyCrow.wrap(@options.delete(:contacts)).compact

        # Channel
        @channel = @options.delete(:channel)
      end

      # Return chatty crow default headers for specific channel
      def headers
        ChattyCrow.default_headers(@channel)
      end

      # Get request for send
      # @return [Hash] Request
      def to_json
        {
          payload: {
            payload: payload,
            contacts: @contacts
          },
          headers: headers
        }
      end
    end
  end
end
