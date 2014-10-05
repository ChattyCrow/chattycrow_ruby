module ChattyCrow
  module Request
    # Android push notification request
    class Android < BaseRequest
      # Initialize android request
      # @param args [Array] Options
      def initialize(*args)
        super(*args)

        # Get payload
        @payload = @options.delete(:payload)

        # Raise error when payload is empty!
        fail ::ArgumentError, 'Payload is empty!' if @payload.nil? || !@payload.is_a?(Hash)

        # Android require data field and the field must be hash!
        if !@payload[:data].is_a?(Hash) || @payload[:data].nil? || @payload[:data].keys.empty?
          fail ::ArgumentError, 'Data in payload is required and it needs to be hash!'
        end
      end
    end
  end
end
