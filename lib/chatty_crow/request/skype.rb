module ChattyCrow
  module Request
    # Skype request
    class Skype < BaseRequest
      def initialize(*args)
        super(*args)

        # If arguments exists set as body into options!
        # Its for just easy ChattyCrow.send_skype 'Hello'
        @options[:body] = @arguments if @arguments

        # Set payload
        @payload = @options
      end
    end
  end
end
