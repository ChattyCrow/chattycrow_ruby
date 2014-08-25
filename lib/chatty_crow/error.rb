# Parent of all ChattyCrow errors
module ChattyCrow
  module Error
    # Parent of all chatty crow error
    # designed to accept RestClient::Response
    class ChattyCrowError < StandardError
      # Json parsed response body
      attr_accessor :response_body, :response

      def initialize(response = nil)
        @response = response
        if @response && @response.body
          @response_body = JSON.parse(@response.body)
          super(@response_body['msg']) if @response_body['msg']
        end
      rescue JSON::ParserError
        @response_body = nil
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/error/*.rb'].sort.each do |path|
  filename = File.basename(path)
  require "chatty_crow/error/#{filename}"
end
