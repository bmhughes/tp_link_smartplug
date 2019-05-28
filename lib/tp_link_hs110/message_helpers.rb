module TpLinkHs110
  module MessageHelpers
    def encrypt(string)
      key = 171
      result = [30].pack('N')
      string.each_char do |char|
        key = a = key ^ char.ord
        result.concat(a.chr)
      end
      return result
    end
    
    def decrypt(string)
      key = 171
      result = ''
      string.each_char do |char|
        a = key ^ char.ord
        key = char.ord
        result.concat(a.chr)
      end
      return result
    end
  end
end