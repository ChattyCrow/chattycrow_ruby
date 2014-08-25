require File.expand_path '../helper', __FILE__

class AndroidTest < MiniTest::Should::TestCase
  should 'Create notification' do
    request = { status: 'OK', msg: 'Success', sucess: 15, total: 15, contacts: [] }
    mock_notification body: request.to_json

    # Create request
    response = ChattyCrow.send_android data: 'Data1', data_test: 'Data Test'

    # Expect response
    expect(response).to_be_kind_of ChattyCrow::Response::Notification
    expect(response.status).to_equal request[:status]
    expect(response.msg).to_equal request[:msg]
    expect(response.success).to_equal request[:success]
    expect(response.total).to_equal request[:total]

    # Clear mock
    clear_mock_url
  end

  should 'Create partial notification' do
    request = { status: 'PERROR', msg: 'Success partial', sucess: 12, total: 15, contacts: %w(test1 test2) }
    mock_notification body: request.to_json, status: %(201 Created)

    # Create request
    response = ChattyCrow.send_android data: 'Data1', data_test: 'Data Test'

    # Expect response
    expect(response).to_be_kind_of ChattyCrow::Response::Notification
    expect(response.status).to_equal request[:status]
    expect(response.msg).to_equal request[:msg]
    expect(response.success).to_equal request[:success]
    expect(response.total).to_equal request[:total]
    expect(response.failed_contacts).to_equal request[:contacts]

    # Clear mock
    clear_mock_url
  end
end
