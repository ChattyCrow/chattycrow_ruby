require 'restclient'

module ChattyCrow
  module ContactsRequest
    def self.get(options)
      execute(options.merge(method: :get)) do |response|
        Response::ContactsList.new response
      end
    end

    def self.add(options)
      # Invalid argument
      raise ::ArgumentError unless options[:contacts]

      # Set as payload
      options[:payload] = { contacts: options.delete(:contacts) }

      # Send command
      execute(options.merge(method: :post)) do |response|
        Response::ContactsAdd.new response
      end
    end

    def self.remove(options)
      # Invalid argument
      raise ::ArgumentError unless options[:contacts]

      # Set as payload
      options[:payload] = { contacts: options.delete(:contacts) }

      # Send command
      execute(options.merge(method: :delete)) do |response|
        Response::ContactsRemove.new response
      end
    end

    def self.contacts_url
      ChattyCrow.configuration.contacts_url
    end

    def self.execute(options, &resp_block)
      # Prepare options (url + headers)
      options[:url]     = contacts_url
      options[:headers] = ChattyCrow.default_headers(options.delete(:channel))

      # Send request
      RestClient::Request.execute(options) do |response, request, result, &block|
        case response.code
        when 200, 201
          if block_given?
            resp_block.call(response)
          else
            response
          end
        when 301, 302, 307
          response.follow_redirection(request, result, &block)
        when 401, 404
          raise Error::UnauthorizedRequest
        end
      end
    end
  end
end
