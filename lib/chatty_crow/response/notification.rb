module ChattyCrow
  module Response
    # Notification response
    class Notification < Base
      attr_accessor :success, :total, :failed_contacts, :message_id

      # Actual channel & token
      attr_accessor :token, :channel

      # Initialize notification response
      # @param response [RestClient::Response] Response from server
      # @param options [Hash] Headers
      def initialize(response, options)
        super response

        # Parse response
        @success         = @body.delete('success')
        @total           = @body.delete('total')
        @failed_contacts = @body.delete('contacts')
        @message_id      = @body.delete('message_id')

        # Parse headers for message
        @channel = options[:headers]['Channel']
        @token   = options[:headers]['Token']
      end

      # Get instance of message
      # @return Message [ChattyCrow::Message]
      def message
        @message ||= ::ChattyCrow::Message.new(channel: @channel, token: @token, message_id: @message_id)
      end
    end
  end
end
