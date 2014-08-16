module ChattyCrow
  module Response
    class ContactsList < Base
      attr_accessor :contacts

      def initialize(response)
        super response
        @contacts = @body['contacts']
      end
    end
  end
end
