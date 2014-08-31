require File.expand_path '../helper', __FILE__

# Base parser test
class BaseParserTest < MiniTest::Should::TestCase
  should 'Raise UnauthorizedRequest when invalid channel or token was send' do
    # Fake URL for contacts
    mock_contacts status: %w(401 Unauthorized)

    # Call for Contacts!
    expect { ChattyCrow.get_contacts }.to_raise ChattyCrow::Error::UnauthorizedRequest

    # Remove mock
    clear_mock_url
  end

  should 'Raise ChannelNotFound when invalid channel or token was send' do
    # Fake URL for contacts
    mock_contacts status: ['404', 'Not Found']

    # Call for Contacts!
    expect { ChattyCrow.get_contacts }.to_raise ChattyCrow::Error::ChannelNotFound

    # Remove mock
    clear_mock_url
  end

  should 'Raise InvalidReturn when invalid response accepted' do
    # Fake URL for contacts
    mock_contacts status: ['500', 'Internal Server Error']

    # Call for Contacts!
    expect { ChattyCrow.get_contacts }.to_raise ChattyCrow::Error::InvalidReturn

    # Remove mock
    clear_mock_url
  end
end
