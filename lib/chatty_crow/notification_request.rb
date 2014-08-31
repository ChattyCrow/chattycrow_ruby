require 'rest_client'

module ChattyCrow
  # Notification request
  # use for send different kind
  # of notifications
  class NotificationRequest
    def self.send(klass, *args)
      instance = klass.new(*args)
      execute(instance)
    end

    def self.notification_url
      ChattyCrow.configuration.notification_url
    end

    # Method actually sends created request to server
    # @param instance [Request::Base] Request children class
    # @param raise_errors [Boolean] Raise errors if error?
    # @return [Object] Raise an exception or return Response::Notification
    def self.execute(instance, raise_errors = true)
      options = instance.to_json.merge(url: notification_url, method: :post)

      RestClient::Request.execute(options) do |response, request, result, &block|
        begin
          case response.code
          when 200, 201
            Response::Notification.new response
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
      end
    end
  end
end
