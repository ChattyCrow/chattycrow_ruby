module ChattyCrow
  module Error
    class InvalidAttributes < ChattyCrowError
      # List of invalid attributes
      attr_accessor :attributes

      def initialize()
        super "Unauthorized ChattyCrow request"

        # Get parameters from response
        if @response_body && @response_body['parameters']
          @attributes = @response_body['parameters']
        else
          @attributes = []
        end
      end
    end
  end
end
