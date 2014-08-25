# Parent of all ChattyCrow errors
module ChattyCrow
  module Response
    # Parent of all responses
    class Base
      # Parse response from RestClient
      attr_accessor :code, :body, :status, :msg

      def initialize(response)
        @code   = response.code
        @body   = JSON.parse(response.body)
        @status = @body.delete('status')
        @msg    = @body.delete('msg')
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/response/*.rb'].sort.each do |path|
  filename = File.basename(path)
  require "chatty_crow/response/#{filename}"
end
