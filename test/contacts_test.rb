require File.expand_path '../helper', __FILE__

# Unit test for contact methods
class ContactsTest < MiniTest::Should::TestCase
  should 'Return contact list' do
    # Fake URL contacts
    mock_contacts body: { contacts: %w(test1 test2) }.to_json

    # Get contacts
    response = ChattyCrow.get_contacts

    # Validate
    expect(response).to_be_kind_of ChattyCrow::Response::ContactsList
    expect(response.contacts).to_include 'test1'
    expect(response.contacts).to_include 'test2'

    # Remove mock
    clear_mock_url
  end

  should 'Raise invalid argument when no contact list is present' do
    expect { ChattyCrow.add_contacts }.to_raise ArgumentError
    expect { ChattyCrow.remove_contacts }.to_raise ArgumentError
  end

  should 'Return contact add list' do
    # Prepare response
    request = {
      status: 'OK',
      msg: 'Status message',
      stats: {
        success: 15,
        exists: 28,
        failed: 12
      },
      contacts: {
        exists: %w(franta1 franta5),
        failed: %w(franta2 franta3)
      }
    }

    # Fake URL contacts
    mock_contacts method: :post, body: request.to_json

    # Get contacts
    response = ChattyCrow.add_contacts(contacts: %w(franta12 franta15))

    # Validate
    expect(response).to_be_kind_of ChattyCrow::Response::ContactsAdd
    expect(response.status).to_equal request[:status]
    expect(response.msg).to_equal request[:msg]

    # Statistics
    expect(response.success_count).to_equal request[:stats][:success]
    expect(response.exists_count).to_equal request[:stats][:exists]
    expect(response.failed_count).to_equal request[:stats][:failed]

    # Failed & Exists contacts
    expect(response.exists).to_include 'franta1'
    expect(response.exists).to_include 'franta5'
    expect(response.failed).to_include 'franta2'
    expect(response.failed).to_include 'franta3'

    # Remove mock
    clear_mock_url
  end

  should 'Return contact remove list' do
    # Prepare response
    request = {
      status: 'OK',
      msg: 'Status message',
      stats: {
        success: 15,
        failed: 12
      },
      contacts: {
        failed: %w(franta2 franta3)
      }
    }

    # Fake URL contacts
    mock_contacts method: :delete, status: %w(201 Created), body: request.to_json

    # Get contacts
    response = ChattyCrow.remove_contacts(contacts: %w(franta12 franta15))

    # Validate
    expect(response).to_be_kind_of ChattyCrow::Response::ContactsRemove
    expect(response.status).to_equal request[:status]
    expect(response.msg).to_equal request[:msg]

    # Statistics
    expect(response.success_count).to_equal request[:stats][:success]
    expect(response.failed_count).to_equal request[:stats][:failed]

    # Failed & Exists contacts
    expect(response.failed).to_include 'franta2'
    expect(response.failed).to_include 'franta3'

    # Remove mock
    clear_mock_url
  end
end
