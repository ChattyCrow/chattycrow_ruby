module ChattyCrow
  module Error
    class ChannelNotFound < ChattyCrowError
      def initialize
        super "Invalid ChattyCrow channel"
      end
    end
  end
end
