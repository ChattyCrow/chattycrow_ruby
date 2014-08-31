require File.expand_path '../helper', __FILE__
require 'base64'

# Mail test
class MailTest < MiniTest::Should::TestCase
  let(:valid_mail) { ChattyCrow.create_mail subject: 'test', text_body: 'text body', contacts: 'test@netbrick.eu' }
  let(:invalid_mail) { ChattyCrow.create_mail subject: 'test' }
  let(:mail) { ChattyCrow.create_mail subject: 'test', text_body: 'text_body', html_body: 'html_body', contacts: 'test@netbrick.eu' }

  should 'create mail' do
    expect(valid_mail).to_be_instance_of ChattyCrow::Request::Mail
    expect(valid_mail.subject).to_equal 'test'
    expect(valid_mail.text_body).to_equal 'text body'
    expect(valid_mail.contacts).to_include 'test@netbrick.eu'
  end

  should 'raise error when trying deliver without body' do
    expect { invalid_mail.deliver! }.to_raise ::ArgumentError
  end

  should 'return false when trying deliver without body' do
    expect(invalid_mail.deliver).to_equal false
  end

  should 'serializer payload test' do
    json = mail.payload
    expect(json[:subject]).to_equal 'test'
    expect(json[:text_body]).to_equal Base64.encode64('text_body')
    expect(json[:html_body]).to_equal Base64.encode64('html_body')
  end

  should 'raise error unless file is present' do
    expect { mail.add_file {} }.to_raise ::ArgumentError
  end

  should 'raise error if file is string but not filename provided' do
    expect { mail.add_file file: 'base64data', mime_type: 'image/jpeg' }.to_raise ::ArgumentError
  end

  should 'raise error if file is string but not mime-type provided' do
    expect { mail.add_file file: 'base64data', filename: 'test.jpeg' }.to_raise ::ArgumentError
  end

  should 'decide mime type and filename from factory' do
    file = File.open('test/factories/stewie.jpeg')
    attachment = mail.add_file file: file
    expect(attachment).to_be_instance_of ChattyCrow::Request::Attachment
    expect(attachment.filename).to_equal 'stewie.jpeg'
    expect(attachment.mime_type).to_equal 'image/jpeg'
  end

  should 'test attachment serializer' do
    file = File.open('test/factories/stewie.jpeg')
    attachment = mail.add_file file: file
    json  = attachment.to_json
    file.seek(0)
    expect(json[:name]).to_equal 'stewie.jpeg'
    expect(json[:mime_type]).to_equal 'image/jpeg'
    expect(json[:inline]).to_equal false
    expect(json[:base64data]).to_equal Base64.encode64(file.read)
  end
end
