module ChattyCrow
  module Request
    # Ios push notification request
    class Ios < BaseRequest
      def initialize(*args)
        super(*args)

        # Set payload
        if @arguments.any?
          @payload = @arguments_flatten
        else
          @payload = @options
        end
      end
    end
  end
end
