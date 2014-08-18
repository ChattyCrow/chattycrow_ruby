module ChattyCrow
  module Response
    class ContactsRemove < Base
      # Statistics
      attr_accessor :success_count, :failed_count

      # Failed contacts
      attr_accessor :failed

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

      def ok?
        @status.to_s.downcase == 'ok'
      end

      def partial_error?
        @status.to_s.downcase == 'perror'
      end

      def error?
        @status.to_s.downcase == 'error'
      end

      def failed
        @failed || []
      end
    end
  end
end
