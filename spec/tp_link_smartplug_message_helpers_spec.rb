require 'tp_link_smartplug/message_helpers'

class DummyClass
  include TpLinkSmartplug::MessageHelpers
end

RSpec.describe TpLinkSmartplug::MessageHelpers do
  dc = DummyClass.new

  string = 'test'
  encrypted = "\x00\x00\x00\x04\xDF\xBA\xC9\xBD".force_encoding(Encoding::ASCII_8BIT)

  it 'encrypts' do    
    expect(dc.encrypt(string)).not_to be nil
    expect(dc.encrypt(string)).to eql(encrypted)
  end

  it 'decrypts' do
    expect(dc.decrypt(encrypted[4..])).not_to be nil
    expect(dc.decrypt(encrypted[4..])).to eql(string)
  end
end
