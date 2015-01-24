require 'rest_client'

module ChattyCrow
  # Batch notification request
  # use for send different kind
  # of notifications
  class BatchNotificationRequest
    # Prepare data
    attr_accessor :requests, :token

    def initialize(token = nil)
      @token = token
    end

    def requests
      @requests ||= []
    end

    # Add requests by type
    def add_mail(*args)
      add_other Request::Mail.new(*args)
    end

    def add_ios(*args)
      add_other Request::Ios.new(*args)
    end

    def add_android(*args)
      add_other Request::Android.new(*args)
    end

    def add_skype(*args)
      add_other Request::Skype.new(*args)
    end

    def add_hipchat(*args)
      add_other Request::HipChat.new(*args)
    end

    def add_slack(*args)
      add_other Request::Slack.new(*args)
    end

    def add_jabber(*args)
      add_other Request::Jabber.new(*args)
    end

    # Add other with channel name
    def add_other(instance)
      # Throw error when instance has empty channel
      fail ::ArgumentError, 'Channel is required' unless instance.channel

      # Add
      requests << instance
    end

    # Send
    def execute
      proceed(false)
    end

    # Send with errors!
    def execute!
      proceed(true)
    end

    # :nodoc:
    def self.batch_notification_url
      ChattyCrow.configuration.batch_url
    end

    # Batch headers
    def batch_headers
      ChattyCrow.batch_headers(@token)
    end

    private

    # Method actually sends created request to server
    # [Can be refactored, with request class]
    # @param raise_errors [Boolean] Raise errors if error?
    # @return [Object] Raise an exception or return Response::Notification
    def proceed(raise_errors = true)
      # Empty requests?
      if requests.empty?
        if raise_errors
          fail ::ArgumentError, 'At least one message is required!'
        else
          return false
        end
      end

      # Headers
      options = { headers: batch_headers, url: self.class.batch_notification_url, method: :post }

      # Create array!
      options[:payload] = { channels: requests.map { |i| i.to_json(true)[:payload] } }.to_json

      # Send
      RestClient::Request.execute(options) do |response, request, result, &block|
        begin
          case response.code
          when 200, 201
            Response::Batch.new response, options
          when 301, 302, 307
            response.follow_redirection(request, result, &block)
          when 400
            fail Error::InvalidAttributes, response
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
      end # RestClient
    end # Execute
  end
end
