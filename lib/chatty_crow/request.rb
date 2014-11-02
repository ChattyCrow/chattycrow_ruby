module ChattyCrow
  module Request
    # Parent of all requests to ChattyCrow API
    class BaseRequest
      # Methods
      attr_accessor :contacts, :payload, :channel, :token, :time, :location

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

        # Symbolize keys in options for validations
        ChattyCrow.symbolize_keys!(@options)

        # Create flatten arguments for (skype/android/sms.. requests)
        @arguments_flatten = args.join(', ') if args.any?

        # Recipients
        @contacts = ChattyCrow.wrap(@options.delete(:contacts)).compact

        # Time and location - validate!
        if @time = @options.delete(:time)
          { start: Fixnum, end: Fixnum }.each do |key, klass|
            unless @time[key].is_a?(klass)
              fail ::ArgumentError, "#{key} must be instance of #{klass}"
            end
          end
        end

        if @location = @options.delete(:location)
          { latitude: Float, longitude: Float, range: Fixnum }.each do |key, klass|
            unless @location[key].is_a?(klass)
              fail ::ArgumentError, "#{key} must be instance of #{klass}"
            end
          end
        end

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
            contacts: @contacts,
            time: @time,
            location: @location
          },
          headers: headers
        }
      end
    end
  end
end
