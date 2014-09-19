module ChattyCrow
  module Request
    # Ios push notification request
    class Ios < BaseRequest
      def initialize(*args)
        super(*args)

        # Get payload
        @payload = @options.delete(:payload)

        # Raise error when payload is empty!
        raise ::ArgumentError, 'Payload is empty!' unless @payload
      end
    end
  end
end
