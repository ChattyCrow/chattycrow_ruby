require 'rest-client'
require 'chatty_crow/config'
require 'chatty_crow/error'
require 'chatty_crow/response'
require 'chatty_crow/request'
require 'chatty_crow/notification_request'
require 'chatty_crow/contacts_request'

# Automatically load configuration from config/chatty_crow.yml (rails)
require 'chatty_crow/railtie' if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3

module ChattyCrow

  def self.send_mail(options = {})
    NotificationRequest.send Request::Mail, options
  end

  def self.send_ios_push(options = {})
    NotificationRequest.send Request::Ios, options
  end

  def self.send_android_push(options = {})
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
