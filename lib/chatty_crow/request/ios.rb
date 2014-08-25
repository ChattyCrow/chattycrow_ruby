module ChattyCrow
  module Request
    class Ios < BaseRequest
      def initialize(options = {})
        super options

        # Set payload
        @payload = options
      end
    end
  end
end
