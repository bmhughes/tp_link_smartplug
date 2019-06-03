# frozen_string_literal: true

require 'time'

module TpLinkSmartplug
  # Generic helper methods
  module Helpers
    def debug_message(string)
      caller_method = caller_locations(1..1).label
      Time.now.strftime('%Y-%m-%d %H:%M:%S: ').concat("#{caller_method}: ").concat(string)
    end
  end
end
