module ChattyCrow
  module Request
    # Parent of all requests to ChattyCrow API
    class BaseRequest
      # Methods
      attr_accessor :contacts, :payload, :channel, :token

      # Intialize options!
      attr_accessor :arguments, :options, :arguments_flatten

      # Intialize (almost everwhere called by super)
      # @param args [Array] options for request
      def initialize(*args)
        # Error when attributes not exists!
        fail ::ArgumentError if args.empty?

        # Parse options and arguments
        # Arguments can be simple message!
        @options   = ChattyCrow.extract_options!(args)
        @arguments = args

        # Create flatten arguments for (skype/android/sms.. requests)
        @arguments_flatten = args.join(', ') if args.any?

        # Recipients
        @contacts = ChattyCrow.wrap(@options.delete(:contacts)).compact

        # Channel
        @channel = @options.delete(:channel)

        # Token
        @token   = @options.delete(:token)
      end

      # Return chatty crow default headers for specific channel
      def headers
        ChattyCrow.default_headers(@channel, @token)
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
