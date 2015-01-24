# Parent of all ChattyCrow errors
module ChattyCrow
  module Response
    # Parent of all responses
    class Base
      # Parse response from RestClient
      attr_accessor :code, :body, :status, :msg

      def initialize(response)
        if response.is_a?(String)
          @code   = response.code
          @body   = JSON.parse(response.body)
        else
          @code = -1
          @body = response
        end

        @status = @body.delete('status')
        @msg    = @body.delete('msg')
      end

      def status
        @status.to_s
      end

      def ok?
        @status.downcase.downcase == 'ok'
      end

      def partial_error?
        @status.downcase.downcase == 'perror'
      end

      def error?
        @status.downcase.downcase == 'error'
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/response/*.rb'].sort.each do |path|
  filename = File.basename(path)
  require "chatty_crow/response/#{filename}"
end
