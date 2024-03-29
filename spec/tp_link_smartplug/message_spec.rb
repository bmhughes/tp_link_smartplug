require 'tp_link_smartplug/message'

class DummyClass
  include TpLinkSmartplug::Message
end

RSpec.describe TpLinkSmartplug::Message do
  dc = DummyClass.new

  string = 'test'
  encrypted = "\x00\x00\x00\x04\xDF\xBA\xC9\xBD".force_encoding(Encoding::ASCII_8BIT)

  it 'encrypts' do
    expect(dc.encrypt(string)).not_to be_nil
    expect(dc.encrypt(string)).to eql(encrypted)
  end

  it 'decrypts' do
    expect(dc.decrypt(encrypted[4..encrypted.length])).not_to be_nil
    expect(dc.decrypt(encrypted[4..encrypted.length])).to eql(string)
  end
end
