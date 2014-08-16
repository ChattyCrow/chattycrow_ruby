module ChattyCrow
  module Response
    class ContactsAdd < Base
      # Statistics
      attr_accessor :success_count, :exists_count, :failed_count

      # Contact lists
      attr_accessor :exists, :failed

      def initialize(response)
        super response

        # Parse response
        stats     = @body.delete('stats')
        contacts  = @body.delete('contacts')

        # Set statistics
        if stats
          @success_count = stats.delete('success')
          @exists_count  = stats.delete('exists')
          @failed_count  = stats.delete('failed')
        end

        # Set contacts
        if contacts
          @exists = contacts.delete('exists')
          @failed = contacts.delete('failed')
        end
      end

      def exists
        @exists || []
      end

      def failed
        @failed || []
      end
    end
  end
end

