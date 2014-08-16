require 'chatty_crow'
require 'rubygems'
require 'fakeweb'
require 'minitest/autorun'
require 'minitest/should'
require 'coveralls'

Coveralls.wear!

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
