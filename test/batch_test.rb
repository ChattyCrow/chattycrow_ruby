require File.expand_path '../helper', __FILE__

# Batch test
class BatchTest < MiniTest::Should::TestCase
  should 'use default token' do
    batch = ChattyCrow.create_batch
    batch.add_ios payload: 'Dear users', channel: 'test#1'

    # Mock batch
    body = {
      channels: [
        {
          channel: 'channel#2',
          status: 'PERROR',
          msg: '10 of 15 created',
          success: 10,
          total: 15,
          contacts: %w(test1 test2),
          message_id: 1
        },
      ]
    }
    mock_batch status: %(200 Ok), body: body.to_json

    # Call
    batch.execute!

    # Compare last token
    expect(last_headers['token']).to_equal ChattyCrow.configuration.token
  end

  should 'raise error when try to add service without channel' do
    batch = ChattyCrow.create_batch
    expect { batch.add_ios(payload: 'Dear users') }.to_raise ::ArgumentError
  end

  should 'return valid notification response' do
    FIRST_CHANNEL = 'channel#1'

    # Mock notification
    body = {
      channels: [
        {
          channel: FIRST_CHANNEL,
          status: 'OK',
          msg: '15 of 15 created',
          success: 15,
          total: 15,
          contacts: [],
          message_id: 1
        },
        {
          channel: 'channel#2',
          status: 'PERROR',
          msg: '10 of 15 created',
          success: 10,
          total: 15,
          contacts: %w(test1 test2),
          message_id: 1
        },
      ]
    }
    mock_batch status: %(200 Ok), body: body.to_json

    # Create batch
    batch = ChattyCrow.create_batch

    # Add some payloads
    batch.add_ios(payload: 'Dear IOS users', channel: FIRST_CHANNEL)
    batch.add_skype(payload: 'Dear SKYPE users', channel: 'channel#2')

    # Response
    response = batch.execute!

    # Parse response
    expect(response.channels.count).to_equal 2

    # Get response for first channel
    channel  = response.channels[FIRST_CHANNEL]
    template = body[:channels][0]
    expect(channel).to_be_instance_of ChattyCrow::Response::BatchNotification
    expect(channel.status).to_equal template[:status]
    expect(channel.ok?).to_equal true
    expect(channel.partial_error?).to_equal false

    # Get message
    message_body = {
      status: :ok,
      notifications: {
        success: 15,
        waiting: 0,
        error: 0
      }
    }
    mock_message(id: template[:message_id], body: message_body.to_json)
    message = channel.message

    expect(last_headers['token']).to_equal ChattyCrow.configuration.token
    expect(last_headers['channel']).to_equal FIRST_CHANNEL

    expect(message.channel).to_equal FIRST_CHANNEL
    expect(message.message_id).to_equal template[:message_id]
    expect(message.token).to_equal ChattyCrow.configuration.token
    expect(message.success).to_equal message_body[:notifications][:success]
    expect(message.waiting).to_equal message_body[:notifications][:waiting]
    expect(message.error).to_equal message_body[:notifications][:error]

    # Clear mocks
    clear_mock_url
  end
end

