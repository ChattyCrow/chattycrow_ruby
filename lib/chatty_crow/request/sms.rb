module ChattyCrow
  module Request
    # SMS request
    class Sms < BaseRequest
      def initialize(*args)
        super(*args)

        # If arguments exists set as body into options!
        # Its for just easy ChattyCrow.send_jabber 'Hello'
        @options[:body] = @arguments.flatten.join(', ') if @arguments.any?

        # Set payload
        @payload = @options
      end
    end
  end
end
