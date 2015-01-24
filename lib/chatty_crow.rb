require 'rest-client'
require 'chatty_crow/config'
require 'chatty_crow/error'
require 'chatty_crow/response'
require 'chatty_crow/message'
require 'chatty_crow/request'
require 'chatty_crow/request/android'
require 'chatty_crow/request/ios'
require 'chatty_crow/request/jabber'
require 'chatty_crow/request/mail'
require 'chatty_crow/request/skype'
require 'chatty_crow/request/sms'
require 'chatty_crow/request/hipchat'
require 'chatty_crow/request/slack'
require 'chatty_crow/response/notification'
require 'chatty_crow/response/batch'
require 'chatty_crow/response/contacts_add'
require 'chatty_crow/response/contacts_remove'
require 'chatty_crow/notification_request'
require 'chatty_crow/batch_notification_request'
require 'chatty_crow/contacts_request'

# Load Rails Components
#
# * Railitie - load config/chatty_crow.yml settings!
# * ActionMailer - extension to easy send mails via cc
if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
  require 'chatty_crow/railtie'
  require 'chatty_crow/action_mailer_extension'
end

# ChattyCrow global default module entry point to easy send notifications
#
#   # Mail
#   response = ChattyCrow.send_mail
#
#   # Create mail & send by .deliver!
#   mail = ChattyCrow.create_mail subject: 'test'
#
#   # IOS
#   response = ChattyCrow.send_ios data: 'news'
#
#   # Android
#   response = ChattyCrow.send_android data: 'news', contats: [ 'test1' ]
#
#   # Skype
#   response = ChattyCrow.send_skype data: 'news'
#
#   # Jabber
#   response = ChattyCrow.send_android data: 'news'
#
#   # Sms
#   response = ChattyCrow.send_sms 'news'
#
# Or work with contacts
#
#   # Get all contacts
#   response = ChattyCrow.get_contacts
#
#   # Add contact
#   response = ChattyCrow.add_contacts 'test1', 'test2'
#
#   # Remove contacts
#   response = ChattyCrow.remove_contacts 'test1', 'test2'
module ChattyCrow
  def self.send_mail(*args)
    NotificationRequest.send(Request::Mail, *args)
  end

  def self.create_mail(*args)
    Request::Mail.new(*args)
  end

  def self.send_ios(*args)
    NotificationRequest.send(Request::Ios, *args)
  end

  def self.send_android(*args)
    NotificationRequest.send(Request::Android, *args)
  end

  def self.send_skype(*args)
    NotificationRequest.send(Request::Skype, *args)
  end

  def self.send_hipchat(*args)
    NotificationRequest.send(Request::HipChat, *args)
  end

  def self.send_slack(*args)
    NotificationRequest.send(Request::Slack, *args)
  end

  def self.send_jabber(*args)
    NotificationRequest.send(Request::Jabber, *args)
  end

  def self.send_sms(*args)
    NotificationRequest.send(Request::Sms, *args)
  end

  def self.get_contacts(options = {})
    ContactsRequest.get(options)
  end

  def self.add_contacts(*args)
    ContactsRequest.add(*args)
  end

  def self.remove_contacts(*args)
    ContactsRequest.remove(*args)
  end

  # Create batch request
  def self.create_batch(token = nil)
    BatchNotificationRequest.new(token)
  end

  # Helper method for wrapping non-array objects
  # @param object [Object] Something
  # @return [Array] Array
  def self.wrap(object)
    if object.nil?
      []
    elsif object.respond_to?(:to_ary)
      object.to_ary || [object]
    else
      [object]
    end
  end

  # Helper method for extrat options from array!
  def self.extract_options!(args)
    if args.last.is_a?(Hash) && args.last.instance_of?(Hash)
      args.pop
    else
      {}
    end
  end

  # Symbolize keys
  def self.symbolize_keys!(hash)
    hash.keys.each do |key|
      # Get value
      value = hash.delete(key)

      # Save as sym
      hash[(key.to_sym rescue key)] = value

      # Recursive?
      symbolize_keys!(hash[key.to_sym]) if value.is_a?(Hash)
    end
    true
  end
end
