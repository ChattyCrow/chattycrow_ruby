module ChattyCrow
  module Error
    class InvalidAttributes < ChattyCrowError
      # List of invalid attributes
      attr_accessor :attributes

      def initialize(attr = [])
        super "Unauthorized ChattyCrow request"
        @attributes = attr
      end
    end
  end
end
