module ChattyCrow
  # Action Mailer Rails Extension to easy use
  # ChattyCrow without modification actuall code
  module ActionMailerExtension
    def self.included(base)
      base.class_eval do
        class << self
          attr_accessor :cc_channel
        end

        # Instance mail request
        attr_accessor :cc_mail

        # Override message with chatty crow message
        def message
          @cc_mail ||= ChattyCrow::Request::Mail.new(self.class, @_message)
        end
      end
      base.extend(ClassMethods)
    end

    # Class methods
    module ClassMethods
      # Set other than default channel
      # @param channel [String] Different channel
      def chatty_crow_channel(channel)
        self.cc_channel = channel
      end
    end
  end
end
