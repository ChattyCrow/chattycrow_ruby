module ChattyCrow
  module Response
    # Contact remove response
    class ContactsRemove < Base
      # Statistics
      attr_accessor :success_count, :failed_count

      # Failed contacts
      attr_accessor :failed

      # Initialize contact add response
      # @param response [RestClient::Response] Response from server
      def initialize(response)
        super response

        # Parse response
        stats     = @body.delete('stats')
        contacts  = @body.delete('contacts')

        # Set statistics
        if stats
          @success_count = stats.delete('success')
          @failed_count  = stats.delete('failed')
        end

        # Set contacts
        @failed = contacts.delete('failed') if contacts
      end

      def failed
        @failed || []
      end
    end
  end
end
