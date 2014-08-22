module ChattyCrow
  module Request
    class Ios
      def initialize(options = {})
        super options

        # Set payload
        @payload = options
      end
    end
  end
end
