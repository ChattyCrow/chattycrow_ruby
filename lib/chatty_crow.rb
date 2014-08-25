require 'rest-client'
require 'chatty_crow/config'
require 'chatty_crow/error'
require 'chatty_crow/response'
require 'chatty_crow/request'
require 'chatty_crow/request/android'
require 'chatty_crow/request/ios'
require 'chatty_crow/request/jabber'
require 'chatty_crow/request/mail'
require 'chatty_crow/request/skype'
require 'chatty_crow/request/sms'
require 'chatty_crow/notification_request'
require 'chatty_crow/contacts_request'

# Automatically load configuration from config/chatty_crow.yml (rails)
require 'chatty_crow/railtie' if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3

# ChattyCrow global default module entry point to easy send notifications
#
#   # Mail
#   response = ChattyCrow.send_mail
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
#   response = ChattyCrow.add_contacts contacts: [ 'test1' ]
#
#   # Remove contacts
#   response = ChattyCrow.remove_contacts contacts: [ 'test2' ]
module ChattyCrow

  def self.send_mail(options = {})
    NotificationRequest.send Request::Mail, options
  end

  def self.send_ios(options = {})
    NotificationRequest.send Request::Ios, options
  end

  def self.send_android(options = {})
    NotificationRequest.send Request::Android, options
  end

  def self.send_skype(options = {})
    NotificationRequest.send Request::Skype, options
  end

  def self.send_jabber(options = {})
    NotificationRequest.send Request::Jabber, options
  end

  def self.send_sms(options = {})
    NotificationRequest.send Request::Sms, options
  end

  def self.get_contacts(options = {})
    ContactsRequest.get options
  end

  def self.add_contacts(options = {})
    ContactsRequest.add options
  end

  def self.remove_contacts(options = {})
    ContactsRequest.remove options
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
end
