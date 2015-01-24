require 'rest_client'

module ChattyCrow
  # Message status
  # It's bind to /api/message_id call
  class Message
    # Attribute
    attr_accessor :channel, :token, :message_id

    # Actual states
    attr_accessor :success, :waiting, :error, :last_update, :status

    # Only message_id is required, in case other options
    # are not different from global configuration
    def initialize(opts = {})
      # Set variables
      @channel    = opts.delete(:channel)
      @token      = opts.delete(:token)
      @message_id = opts.delete(:message_id)

      # Refresh
      refresh
    end

    # Refresh
    def refresh!
      refresh_data
    end

    def refresh
      refresh_data(true)
    end

    private

    def data=(response)
      # Parse body
      body = JSON.parse(response.body)
      @status  = body.delete('status')
      @success = body['notifications'].delete('success')
      @waiting = body['notifications'].delete('waiting')
      @error   = body['notifications'].delete('error')

      # Set last update
      @last_update = Time.now
    end

    def call_options
      {
        url: "#{ChattyCrow.configuration.messages_url}/#{@message_id}",
        headers: ChattyCrow.default_headers(@channel, @token),
        method: :get
      }
    end

    def refresh_data(raise_errors = false)
      # Send request
      RestClient::Request.execute(call_options) do |response, request, result, &block|
        begin
          case response.code
          when 200
            self.data = response
          when 301, 302, 307
            response.follow_redirection(request, result, &block)
          when 401
            fail Error::UnauthorizedRequest, response
          when 404
            fail Error::ChannelNotFound, response
          else
            fail Error::InvalidReturn, response
          end
        rescue => e
          if raise_errors
            raise e
          else
            false
          end
        end
      end
    end
  end
end
