require 'base64'

module ChattyCrow
  module Request
    # Mail request
    class Mail < BaseRequest
      # Mail data
      #
      # * Mail subject
      # * Text mail body
      # * Html mail body
      # * Attachments
      attr_accessor :subject, :text_body, :html_body, :attachments

      # Action Mailer mail!
      attr_accessor :am_mail, :am_klass

      # Create mail from options
      # @param args [Array] Options
      def initialize(*args)
        # Super parse arguments
        super(*args)

        # Delete required parts
        @subject   = @options.delete(:subject)
        @text_body = @options.delete(:text_body)
        @html_body = @options.delete(:html_body)
      end

      # Create mail request from
      # @param klass [ActionMailer::Base] Action mailer class
      # @param mail [Mail::Message] Rails mail
      def initialize(klass, mail)
        # Set Mail::Message and Mailer class
        @am_mail  = mail
        @am_klass = klass
      end

      # Method missing (Rails Action Mailer extension)
      # Forward methods to Mail::Message from ActionMailer
      def method_missing(method_name, *args)
        if @am_mail && @am_mail.respond_to?(method_name)
          @am_mail.send(method_name, *args)
        else
          super
        end
      end

      # Override deliver method from Mail::Message
      # @return [ChattyCrow::Response] Response
      def deliver
        NotificationRequest.execute(self, false)
      end

      # Raise errors if error
      def deliver!
        NotificationRequest.execute(self)
      end

      # Payload method
      def payload
        # Set data from Action mailer
        set_data_from_am if @am_mail

        # Prepare payload!
        {
          subject: @subject,
          html_body: Base64.encode64(@html_body || ''),
          text_body: Base64.encode64(@text_body || '')
        }
      end

      private

      # Set all data from Mail::Message
      def set_data_from_am
        # Contacts
        @contacts  = ChattyCrow.wrap(@am_mail.to)

        # Channel?
        @channel = @am_klass.cc_channel

        # Subject
        @subject = @am_mail.subject

        # Body parts!
        @am_mail.body.parts.each do |part|
          content_type = part.content_type

          if content_type.include?('text/html')
            @html_body = part.body.raw_source
          end

          if content_type.include?('text/plain')
            @text_body = part.body.raw_source
          end
        end
      end
    end
  end
end
