require 'time'

module TpLinkHs110
  module Helpers
    def debug_message(string)
      Time.now.strftime('%Y-%m-%d %H:%M:%S: ').concat(string)
    end
  end
end