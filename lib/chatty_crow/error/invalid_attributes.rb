module ChattyCrow
  module Error
    class InvalidAttributes < ChattyCrowError
      def initialize(attr = [])
        super "Unauthorized ChattyCrow request"
      end
    end
  end
end
