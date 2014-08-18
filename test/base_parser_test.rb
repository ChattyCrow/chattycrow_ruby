require File.expand_path '../helper', __FILE__

# Base parser test
class BaseParserTest < MiniTest::Should::TestCase
  should 'Raise ChattyCrow::Error::UnauthorizedRequest when invalid channel or token was send' do
    # Fake URL for contacts
    mock_contacts status: [%w(401 Unauthorized)]

    # Call for Contacts!
    expect { ChattyCrow.get_contacts }.to_raise ChattyCrow::Error::UnauthorizedRequest

    # Remove mock
    clear_mock_url
  end
end
