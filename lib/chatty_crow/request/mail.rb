require 'base64'
require 'mime/types'

module ChattyCrow
  module Request
    # Support class for Attachments!
    class Attachment
      # Attachment data!
      # * File = FD
      # * Name = File Name
      # * Mime = Mime/type
      attr_accessor :file, :filename, :mime_type, :inline

      # Initializer - set variables
      def initialize(options = {})
        @file      = options.delete(:file)
        @filename  = options.delete(:filename)
        @mime_type = options.delete(:mime_type)
        @inline    = options.delete(:inline)
      end

      # To json
      # @return [Hash] JSon hash for API
      def to_json
        {
          name:       @filename,
          mime_type:  @mime_type,
          base64data: file_base64,
          inline:     @inline ? true : false
        }
      end

      private

      # File base 64 decide what file descriptor means
      # and return BASE 64
      def file_base64
        f = @file

        # ActionDispatch::Http::UploadedFile (get tempfile)
        if defined?(::ActionDispatch) && f.instance_of?(::ActionDispatch::Http::UploadedFile)
          f = f.tempfile
        end

        case f.class.name
        when 'String' # File is String = Base 64 already!
          f
        when 'Tempfile', 'File'
          # Seek to start
          f.seek(0)

          # Read
          Base64.encode64(f.read)
        else
          # Try to convert to base 64!
          if f.respond_to?(:to_s)
            Base64.encode64(f.to_s)
          else
            Base64.encode64(f)
          end
        end
      end
    end

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

        # Parse email or email from Rails
        if action_mailer?
          @am_klass = @arguments[0]
          @am_mail  = @arguments[1]
        else
          # Delete required parts
          @subject   = @options.delete(:subject)
          @text_body = @options.delete(:text_body)
          @html_body = @options.delete(:html_body)
        end
      end

      # Validate if arguments are from Rails::ActionMailer
      def action_mailer?
        defined?(::Rails) && @arguments && @arguments.count == 2 && @arguments[1].instance_of?(::Mail::Message)
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

      # Add attachments
      def add_file(options = {})
        # Get file
        file = options.delete(:file)

        # Raise argument error when argument file missing!
        fail ::ArgumentError, 'File is required' unless file

        # Other options
        filename  = options.delete(:filename)
        mime_type = options.delete(:mime_type)

        # When file is String! options are required
        if file.is_a?(String) && (filename.to_s.empty? || mime_type.to_s.empty?)
          fail ::ArgumentError, 'Filename and Mime Type options are required if file is base64data string'
        end

        # Create file instance
        attachment = Attachment.new(file: file, filename: filename, mime_type: mime_type)

        # Rails File
        if defined?(::ActionDispatch) && file.instance_of?(::ActionDispatch::Http::UploadedFile)
          attachment.filename  = filename  || file.original_filename
          attachment.mime_type = mime_type || file.content_type
        end

        # Guess filename & mime-types! (only Tempfile or File)
        unless attachment.filename
          attachment.filename = File.basename(file.path)
        end

        unless attachment.mime_type
          mime = MIME::Types.type_for(file.path).first
          attachment.mime_type = mime.simplified if mime
        end

        # Raise arguments error when there is not filename or mime type
        raise ::ArgumentError, 'Mime type is required' unless attachment.mime_type
        raise ::ArgumentError, 'Filename is required' unless attachment.filename

        # Add to attachments
        attachments << attachment

        # Return attachment
        attachment
      end

      # Return attachments - always array!
      def attachments
        @attachments ||= []
      end

      # Override deliver method from Mail::Message
      # @return [ChattyCrow::Response] Response
      def deliver
        if invalid?
          false
        else
          NotificationRequest.execute(self, false)
        end
      end

      # Raise errors if error
      def deliver!
        if invalid?
          fail ::ArgumentError, 'Body is required!'
        else
          NotificationRequest.execute(self)
        end
      end

      # Payload method
      def payload
        # Set data from Action mailer
        set_data_from_am if @am_mail

        # Prepare payload!
        {
          subject: @subject,
          html_body: Base64.encode64(@html_body || ''),
          text_body: Base64.encode64(@text_body || ''),
          attachments: attachments.map(&:to_json)
        }
      end

      private

      def invalid?
        # Set data from Action mailer
        set_data_from_am if @am_mail

        # Text body
        @text_body.to_s.empty? && @html_body.to_s.empty?
      end

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

        Rails.logger.debug "Set html: #{@html_body}\nText: #{@text_body}\n\n"

        # Attachments!
        @am_mail.attachments.each do |attachment|
          # Create file!
          file = ChattyCrow::Request::Attachment.new

          # Inline attachment?
          file.inline = attachment.inline?

          # Set file data
          file.file = Base64.encode64(attachment.body.raw_source)

          # Rails save mime types and names into headers
          header = attachment.header.fields.first

          # Get mime_type!
          if header
            file.mime_type = "#{header.main_type}/#{header.sub_type}"
          else
            file.mime_type = 'text/plain'
          end

          # Get filename
          if header
            file.filename = header.filename
          else
            file.filename = 'unknown_file'
          end

          # Return attachment
          attachments << file
        end
      end
    end
  end
end
