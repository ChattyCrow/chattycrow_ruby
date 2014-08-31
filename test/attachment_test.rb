require File.expand_path '../helper', __FILE__

# Test for attachments
class AttachmentTest < MiniTest::Should::TestCase
  let(:file) { File.open('test/factories/stewie.jpeg', 'rb') }
  let(:attachment) { ChattyCrow::Request::Attachment.new(file: file, filename: 'stewie.jpeg', mime_type: 'image/jpeg', inline: false) }

  should 'valid attachment' do
    expect(attachment.filename).to_equal 'stewie.jpeg'
    expect(attachment.mime_type).to_equal 'image/jpeg'
    expect(attachment.inline).to_equal false
  end
end
