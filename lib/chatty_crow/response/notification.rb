module ChattyCrow
  module Response
    class Notification < Base
      attr_accessor :success, :total, :failed_contacts

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
