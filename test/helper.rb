require 'rubygems'
require 'fakeweb'
require 'minitest/autorun'
require 'minitest/should'
require 'minitest/spec/expect'
require 'simplecov'
require 'coveralls'

# Start Coveralls
SimpleCov.start do
  add_filter '/test/'
end
Coveralls.wear!

# Require Gem
require 'chatty_crow'

# Set chatty_crow by block
ChattyCrow.configure do |config|
  config.token           = 'temporary_token'
  config.default_channel = 'default_channel'
end

# Usefull test helpers
module TestHelpers
  def configuration
    ChattyCrow.configuration
  end

  # Mock default notification url
  def mock_notification(options)
    method = options.delete(:method) || :post
    options[:status] ||= %w(200 OK)

    FakeWeb.register_uri(method, configuration.notification_url, options)
  end

  # Mock default URL for contacts
  def mock_contacts(options)
    method = options.delete(:method) || :post
    options[:status] ||= %w(200 OK)

    FakeWeb.register_uri(method, configuration.contacts_url, options)
  end

  # Get last headers
  def last_headers
    ret = {}
    FakeWeb.last_request.each_header do |key, value|
      ret[key] = value
    end
    ret
  end

  def clear_mock_url
    FakeWeb.clean_registry
  end
end

# Include test helper methods to minitest!
class MiniTest::Should::TestCase
  include ::TestHelpers
end
