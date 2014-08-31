require File.expand_path '../helper', __FILE__

# Response test
class ResponseTest < MiniTest::Should::TestCase
  should 'return valid notification response' do
    # Mock notification
    body = {
      status: 'PERROR',
      msg: '12 of 15 notifications created',
      success: 12,
      total: 15,
      contacts: %w(test1 test2 test3)
    }
    mock_notification status: %(201 Created), body: body.to_json

    # Get response
    response = ChattyCrow.send_ios 'Dear users'
    expect(response.msg).to_equal body[:msg]
    expect(response.code).to_equal 201

    # Status?
    expect(response.status).to_equal body[:status]
    expect(response.partial_error?).to_equal true
    expect(response.ok?).to_equal false
    expect(response.error?).to_equal false

    # Failed contacts
    expect(response.failed_contacts).to_include 'test1'

    # Clear mocks
    clear_mock_url
  end
end
