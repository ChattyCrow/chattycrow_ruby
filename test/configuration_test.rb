require File.expand_path '../helper', __FILE__

# Test for proper gem configuration
class ConfigurationTest < MiniTest::Should::TestCase
  should 'provide defaults' do
    assert_config_default :host, 'https://chattycrow.com/api/v1/'
    assert_config_default :notification_url, 'https://chattycrow.com/api/v1/notification'
    assert_config_default :contacts_url, 'https://chattycrow.com/api/v1/contacts'
    assert_config_default :batch_url, 'https://chattycrow.com/api/v1/batch'
    assert_config_default :token, nil
    assert_config_default :default_channel, nil
    assert_config_default :http_open_timeout, 2
    assert_config_default :http_read_timeout, 5
  end

  should 'use correct url wihtout backslash' do
    config = ChattyCrow::Configuration.new
    url    = 'http://test.com/api/v1'
    config.host = url
    assert_equal url, config.host
    assert_equal "#{url}/notification", config.notification_url
    assert_equal "#{url}/contacts", config.contacts_url
    assert_equal "#{url}/batch", config.batch_url
  end

  should 'use correct url with backslash' do
    config = ChattyCrow::Configuration.new
    url    = 'http://test.com/api/v1/'
    config.host = url
    assert_equal url, config.host
    assert_equal "#{url}notification", config.notification_url
    assert_equal "#{url}contacts", config.contacts_url
    assert_equal "#{url}batch", config.batch_url
  end

  def assert_config_default(option, default_value, config = nil)
    config ||= ChattyCrow::Configuration.new
    assert_equal default_value, config.send(option)
  end
end
