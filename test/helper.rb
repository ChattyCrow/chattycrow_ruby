require 'rubygems'
require 'webmock/minitest'
require 'minitest/autorun'
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
    stub_request(method, configuration.notification_url).to_return(options)
  end

  # Mock default batch url
  def mock_batch(options)
    method = options.delete(:method) || :post
    options[:status] ||= %w(200 OK)
    stub_request(method, configuration.batch_url).to_return(options)
  end

  # Mock messages
  def mock_message(options)
    method = options.delete(:method) || :get
    options[:status] ||= %w(200 OK)
    stub_request(method, "#{configuration.messages_url}/#{options[:id]}").to_return(options)
  end

  # Mock default URL for contacts
  def mock_contacts(options)
    method = options.delete(:method) || :post
    options[:status] ||= %w(200 OK)
    stub_request(method, configuration.contacts_url).to_return(options)
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
    WebMock.reset!
  end
end

# Include test helper methods to minitest!
class MiniTest::Should::TestCase
  include ::TestHelpers
end
