require File.expand_path '../helper', __FILE__

# Base parser test
class BaseParserTest < MiniTest::Should::TestCase
  should 'Raise UnauthorizedRequest when invalid channel or token was send' do
    # Fake URL for contacts
    mock_contacts status: %w(401 Unauthorized)

    # Call for Contacts!
    expect { ChattyCrow.add_contacts 'test1', 'test2' }.to_raise ChattyCrow::Error::UnauthorizedRequest

    # Remove mock
    clear_mock_url
  end

  should 'Raise ChannelNotFound when invalid channel or token was send' do
    # Fake URL for contacts
    mock_contacts status: ['404', 'Not Found']

    # Call for Contacts!
    expect { ChattyCrow.add_contacts 'test1', 'test2' }.to_raise ChattyCrow::Error::ChannelNotFound

    # Remove mock
    clear_mock_url
  end

  should 'Raise InvalidReturn when invalid response accepted' do
    # Fake URL for contacts
    mock_contacts status: ['500', 'Internal Server Error']

    # Call for Contacts!
    expect { ChattyCrow.add_contacts 'test1', 'test2' }.to_raise ChattyCrow::Error::InvalidReturn

    # Remove mock
    clear_mock_url
  end

  should 'Raise InvalidAttributes when attributes missing' do
    body = {
      status: 'ERROR',
      parameters: %w(subject text_body),
      msg: 'Missing parameters'
    }

    # Fake URL for notification
    mock_notification status: ['400', 'Bad Request'], body: body.to_json

    # Get error
    error = nil
    begin
      ChattyCrow.send_ios payload: 'Welcome users'
    rescue => e
      error = e
    end

    expect(error).to_be_instance_of ChattyCrow::Error::InvalidAttributes
    expect(error.attributes).to_include 'subject'
    expect(error.attributes).to_include 'text_body'

    # Remove mock
    clear_mock_url
  end

  should 'Use token from configuration' do
    # Fake URL for notification
    mock_notification status: ['400', 'Bad Request'], body: {}.to_json

    # Send !
    ChattyCrow.send_ios payload: 'Welcome users' rescue nil

    # Get last request
    expect(last_headers['token']).to_equal ChattyCrow.configuration.token

    # Clear
    clear_mock_url
  end

  should 'Use token from parameters' do
    # Fake URL for notification
    mock_notification status: ['400', 'Bad Request'], body: {}.to_json

    # New token
    token = 'test_token'

    # Send !
    ChattyCrow.send_ios payload: 'Welcome users', token: token rescue nil

    # Get last request
    expect(last_headers['token']).to_equal token

    # Clear
    clear_mock_url
  end

  should 'Use contact configuration token' do
    # Fake URL for contacts
    mock_contacts status: %w(401 Unauthorized)

    # Call for Contacts!
    ChattyCrow.add_contacts 'test1' rescue nil

    # Get last request
    expect(last_headers['token']).to_equal ChattyCrow.configuration.token

    # Remove mock
    clear_mock_url
  end

  should 'Use contact token from parameters' do
    # Fake URL for contacts
    mock_contacts status: %w(401 Unauthorized)

    # New token
    token = 'test_token'

    # Call for Contacts!
    ChattyCrow.add_contacts('test1', token: token) rescue nil

    # Get last request
    expect(last_headers['token']).to_equal token

    # Remove mock
    clear_mock_url
  end
end
