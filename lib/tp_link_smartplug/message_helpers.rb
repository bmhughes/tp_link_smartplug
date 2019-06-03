module TpLinkSmartplug
  # Helper methods for plug communication messages
  module MessageHelpers
    # Encrypts a message to send to the smart plug
    #
    # @string format [String] the message to be encrypted
    def encrypt(string)
      key = 171
      result = [string.length].pack('N')
      string.each_char do |char|
        key = a = key ^ char.ord
        result.concat(a.chr)
      end
      result
    end

    # Decrypts a message received from the smart plug
    #
    # @string format [String] the message to be decrypted
    def decrypt(string)
      key = 171
      result = ''
      string.each_char do |char|
        a = key ^ char.ord
        key = char.ord
        result.concat(a.chr)
      end
      result
    end
  end
end
