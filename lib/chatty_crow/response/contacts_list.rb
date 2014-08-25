module ChattyCrow
  module Response
    # Response with contact list
    class ContactsList < Base
      attr_accessor :contacts

      def initialize(response)
        super response
        @contacts = ChattyCrow.wrap @body['contacts']
      end
    end
  end
end
