require_relative 'helpers'

module TpLinkSmartplug
  # Base plug class.
  #
  # @author Ben Hughes
  class Base
    include TpLinkSmartplug::Helpers
  end

  # Base plug error class.
  #
  # @author Ben Hughes
  class BaseError < StandardError; end
end
