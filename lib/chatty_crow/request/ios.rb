module ChattyCrow
  module Request
    # Ios push notification request
    class Ios < BaseRequest
      def initialize(options = {})
        super options

        # Set payload
        @payload = options
      end
    end
  end
end
