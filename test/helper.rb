require 'chatty_crow'
require 'rubygems'
require 'fakeweb'
require 'minitest/autorun'
require 'minitest/should'
require 'minitest/spec/expect'
require 'coveralls'

# Start Coveralls
Coveralls.wear!

# Disallow all net connection
FakeWeb.allow_net_connect = false

# Set chatty_crow by block
ChattyCrow.configure do |config|
  config.token           = 'temporary_token'
  config.default_channel = 'default_channel'
end

module TestHelpers


  def configuration
    ChattyCrow.configuration
  end

  # Mock default notification url
  def mock_notification(options)
    method = options.delete(:method) || :get
    options[:status] ||= 200

    FakeWeb.register_uri(method, configuration.notification_url, options)
  end

  # Mock default URL for contacts
  def mock_contacts(options)
    method = options.delete(:method) || :get
    options[:status] ||= [ '200', 'OK' ]

    FakeWeb.register_uri(method, configuration.contacts_url, options)
  end

  def clear_mock_url
    FakeWeb.clean_registry
  end
end

class MiniTest::Should::TestCase
  include ::TestHelpers
end
