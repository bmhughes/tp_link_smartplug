# frozen_string_literal: true

require 'socket'
require 'ipaddr'
require 'json'
require 'tp_link_smartplug/message'

module TpLinkSmartplug
  # Provides an interface to a plug
  class Device
    include TpLinkSmartplug::Message

    attr_accessor :address
    attr_accessor :timeout
    attr_accessor :port
    attr_accessor :debug

    def initialize(address:, port: 9999)
      @address = IPAddr.new(address, Socket::AF_INET)
      @port = port
      @timeout = 3
      @debug = false
    end

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
        JSON.parse(send(address: @address, port: @port, command: TpLinkSmartplug::Command.const_get(method.upcase), timeout: @timeout, debug: @debug))
      end
    end
  end
end
