require 'restclient'

# Send request to contacts chattycrow API
module ChattyCrow
  # Module contains request for contacts
  module ContactsRequest
    # Add contact request
    # @params args [Arguments]
    # @return [Response::ContactsAdd] Instance
    def self.add(*args)
      # Send contact request
      send_contact_request(Response::ContactsAdd, :post, *args)
    end

    # Remove contact request
    # @params args [Arguments]
    # @return [Response::ContactsRemove] Instance
    def self.remove(*args)
      # Send contact request
      send_contact_request(Response::ContactsRemove, :delete, *args)
    end

    # Return default contacts url
    def self.contacts_url
      ChattyCrow.configuration.contacts_url
    end

    # Method prepare data from add/remove contact
    # @params klass [Class] Initializable class for response
    # @params method [String] HTTP method
    # @params args [Arguments]
    def self.send_contact_request(klass, method, *args)
      # Parse options
      options = ChattyCrow.extract_options!(args)

      # Invalid argument
      fail ::ArgumentError if args.length == 0

      # Set as payload
      options[:payload] = { contacts: args }

      # Send command
      execute(options.merge(method: method)) do |response|
        klass.new response
      end
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

      # Convert payload to JSON
      options[:payload] = options[:payload].to_json

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
