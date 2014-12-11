module ChattyCrow
  module Response
    # Notification response
    class Batch < Base
      # Channels
      attr_accessor :channels

      # Actual channel & token
      attr_accessor :token

      # Initialize notification response
      # @param response [RestClient::Response] Response from server
      # @param options [Hash] Headers
      def initialize(response, options)
        super response

        # Get Token
        @token = options[:headers]['Token']

        puts @body

        # Parse channels!
        @body['channels'].each do |channel|
          channels[channel['channel']] = BatchNotification.new(channel, @token)
        end
      end

      def channels
        @channels ||= {}
      end
    end

    # Batch notification response class
    class BatchNotification
      # Infos
      attr_accessor :success, :total, :failed_contacts, :message_id, :msg

      # Token & channel
      attr_accessor :token, :channel

      # init from response
      def initialize(body, token)
        @token = token

        # Parse response
        @channel         = body.delete('channel')
        @msg             = body.delete('msg')
        @success         = body.delete('success')
        @total           = body.delete('total')
        @failed_contacts = body.delete('contacts')
        @message_id      = body.delete('message_id')
      end

      # Get instance of message
      # @return Message [ChattyCrow::Message]
      def message
        @message ||= ::ChattyCrow::Message.new(channel: @channel, token: @token, message_id: @message_id)
      end
    end
  end
end

