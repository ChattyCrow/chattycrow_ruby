module ChattyCrow
  module Request
    # Ios push notification request
    class Ios < BaseRequest
      def initialize(*args)
        super(*args)

        # If arguments exists set as alert into options!
        @options[:alert] = @arguments if @arguments

        # Set payload
        @payload = @options
      end
    end
  end
end
