module TpLinkSmartplug
  # Helper methods for plug communication messages
  module MessageHelpers
    def encrypt(string)
      key = 171
      result = [string.length].pack('N')
      string.each_char do |char|
        key = a = key ^ char.ord
        result.concat(a.chr)
      end
      result
    end

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
