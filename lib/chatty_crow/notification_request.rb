require 'rest_client'

module ChattyCrow
  class NotificationRequest

    attr_accessor :request

    def self.send(klass, options)
      new(klass, options).execute
    end

    def notification_url
      ChattyCrow.configuration.notification_url
    end

    def initialize(klass, options)
      # Init klass
      @request  = klass.new(options)
    end

    def execute
      options = @request.to_json.merge(url: notification_url, method: :post)

      RestClient::Request.execute(options) do |response, request, result, &block|
        case response.code
        when 200, 201
          Response::Notification.new response
        when 301, 302, 307
          response.follow_redirection(request, result, &block)
        when 400
          raise Error::InvalidAttributes.new(response)
        when 401, 404
          raise Error::UnauthorizedRequest
        end
      end
    end
  end
end
