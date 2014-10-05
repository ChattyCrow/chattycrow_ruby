require 'restclient'

# Send request to contacts chattycrow API
module ChattyCrow
  # Module contains request for contacts
  module ContactsRequest
    def self.add(*args)
      # Parse options
      options = ChattyCrow.extract_options!(args)

      # Invalid argument
      fail ::ArgumentError if args.length == 0

      # Set as payload
      options[:payload] = { contacts: args }

      # Send command
      execute(options.merge(method: :post)) do |response|
        Response::ContactsAdd.new response
      end
    end

    def self.remove(*args)
      # Parse options
      options = ChattyCrow.extract_options!(args)

      # Invalid argument
      fail ::ArgumentError if args.length == 0

      # Set as payload
      options[:payload] = { contacts: args }

      # Send command
      execute(options.merge(method: :delete)) do |response|
        Response::ContactsRemove.new response
      end
    end

    def self.contacts_url
      ChattyCrow.configuration.contacts_url
    end

    # Method actually sends created request to server
    #
    # @param options [Hash] Options for request
    # @param resp_block [Block] Block what to do with sucessfull response
    # @return [Object] Block given execute or RestClient::Response
    def self.execute(options, &resp_block)
      # Prepare options (url + headers)
      options[:url]     = contacts_url
      options[:headers] = ChattyCrow.default_headers(options.delete(:channel), options.delete(:token))

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
        when 401
          fail Error::UnauthorizedRequest, response
        when 404
          fail Error::ChannelNotFound, response
        else
          fail Error::InvalidReturn, response
        end
      end
    end
  end
end
