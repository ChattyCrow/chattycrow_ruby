module ChattyCrow
  module Response
    # Notification response
    class Notification < Base
      attr_accessor :success, :total, :failed_contacts

      # Initialize notification response
      # @param response [RestClient::Response] Response from server
      def initialize(response)
        super response

        # Parse response
        @success         = @body.delete('success')
        @total           = @body.delete('total')
        @failed_contacts = @body.delete('contacts')
      end
    end
  end
end
