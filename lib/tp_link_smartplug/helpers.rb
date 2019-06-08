# frozen_string_literal: true

require 'time'

module TpLinkSmartplug
  # Generic helper methods
  module Helpers
    # Formats a message for output as a debug log
    #
    # @param string [String] the message to be formatted for debug output
    def debug_message(string)
      caller_method = caller_locations(1..1).first.label
      STDOUT.puts(Time.now.strftime('%Y-%m-%d %H:%M:%S: ').concat("#{caller_method}: ").concat(string))
    end
  end
end
