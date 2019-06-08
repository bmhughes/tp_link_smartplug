# frozen_string_literal: true

require 'socket'
require 'ipaddr'
require 'json'
require 'tp_link_smartplug/message'

module TpLinkSmartplug
  # Provides an object to represent to a plug
  #
  # @author Ben Hughes
  # @attr [IPAddr] address IP address of the plug
  # @attr [Integer] port Port to connect to on the plug
  # @attr [Integer] timeout Timeout value for connecting and sending commands to the plug
  # @attr [true, false] debug Control debug logging
  class Device
    include TpLinkSmartplug::Message

    attr_accessor :address
    attr_accessor :port
    attr_accessor :timeout
    attr_accessor :debug

    def initialize(address:, port: 9999)
      @address = IPAddr.new(address, Socket::AF_INET)
      @port = port
      @timeout = 3
      @debug = false
    end

    # @!method info
    #   Return plug information
    #   @return [Hash]
    # @!method on
    #   Turn plug output on
    #   @return [Hash]
    # @!method off
    #   Turn plug output off
    #   @return [Hash]
    # @!method cloudinfo
    #   Return plug cloud account configuration
    #   @return [Hash]
    # @!method wlanscan
    #   Perform a scan for wireless SSIDs
    #   @return [Hash]
    # @!method time
    #   Return system time from the plug
    #   @return [Hash]
    # @!method schedule
    #   Return schedule configured on the plug
    #   @return [Hash]
    # @!method countdown
    #   Return countdown configured on the plug
    #   @return [Hash]
    # @!method antitheft
    #   Unsure
    #   @return [Hash]
    # @!method reboot
    #   Reboot plug
    #   @return [Hash]
    # @!method resry
    #   Reset plug
    #   @return [Hash]
    # @!method energy
    #   Return plug energy data
    #   @return [Hash]

    [
      :info,
      :on,
      :off,
      :cloudinfo,
      :wlanscan,
      :time,
      :schedule,
      :countdown,
      :antitheft,
      :reboot,
      :reset,
      :energy
    ].each do |method|
      define_method method do
        JSON.parse(poll(address: @address, port: @port, command: TpLinkSmartplug::Command.const_get(method.upcase), timeout: @timeout, debug: @debug))
      end
    end
  end
end
