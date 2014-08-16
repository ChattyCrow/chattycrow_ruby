module ChattyCrow
  module Error
    class UnauthorizedRequest < Exception
      attr_accessor :attributes
      def initialize(attr = [])
        super "Invalid ChattyCow authorization attributes!"
        @attributes = attr
      end
    end
  end
end
