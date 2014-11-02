require File.expand_path '../helper', __FILE__

# Unit test for contact methods
class BaseRequestTest < MiniTest::Should::TestCase
  should 'Raise argument error if location filed has an invalid type' do
    expect { ChattyCrow.send_skype 'Test', location: { latitude: 'invalid string', longitude: 'invalid string', range: 'invalid string' } }.to_raise ArgumentError
  end

  should 'Raise argument error if some fields in locations missing' do
    expect { ChattyCrow.send_skype 'Test', location: { latitude: 30.2010102, range: 200 } }.to_raise ArgumentError
  end

  should 'Raise argument error if some fields in time missing' do
    expect { ChattyCrow.send_skype 'Test', time: { start: 4093903 } }.to_raise ArgumentError
  end

  should 'Raise argument error if some fields in time has an invalid type' do
    expect { ChattyCrow.send_skype 'Test', time: { start: '40.2030', end: 'abcd' } }.to_raise ArgumentError
  end
end
