require 'simplecov'
require 'chatty_crow'
require 'test/unit'
require 'rubygems'
require 'fakeweb'
require 'rubygems'
require 'minitest/autorun'
require 'minitest/should'

SimpleCov.start

module TestHelpers
  def mock_url(options)

  end

  def clear_mock_url
    FakeWeb.clean_registry
  end
end

class MiniTest::Should::TestCase
  include ::TestHelpers
end
