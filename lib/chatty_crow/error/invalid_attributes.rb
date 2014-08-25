module ChattyCrow
  module Error
    # Invalid attributes exception
    # throws when some of attributes is missing
    class InvalidAttributes < ChattyCrowError
      # List of invalid attributes
      attr_accessor :attributes

      def initialize(response = nil)
        super response

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
