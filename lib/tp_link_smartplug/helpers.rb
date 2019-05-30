# frozen_string_literal: true

require 'time'

module TpLinkSmartplug
  # Generic helper methods
  module Helpers
    def debug_message(string)
      Time.now.strftime('%Y-%m-%d %H:%M:%S: ').concat(string)
    end
  end
end
