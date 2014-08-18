module ChattyCrow
  module Request
    class Ios
      def initialize(options = {})
        # Parent parse recipients
        super options

        # Set payload
        @payload = options
      end
    end
  end
end
