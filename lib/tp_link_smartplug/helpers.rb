require 'time'

module TpLinkSmartplug
  # Generic helper methods
  module Helpers
    # Formats a message for output as a debug log
    #
    # @param string [String] the message to be formatted for debug output
    def debug_message(string)
      caller_method = caller_locations(1..1).first.label
      $stdout.puts(Time.now.strftime('%Y-%m-%d %H:%M:%S: ').concat("#{caller_method}: ").concat(string))
    end

    # Tests a variable for nil or empty status
    #
    # @param v  the variable to be tested
    def nil_or_empty?(value)
      return true if value.nil? || (value.respond_to?(:empty?) && value.empty?)

      false
    end
  end
end
