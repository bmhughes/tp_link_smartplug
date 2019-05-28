require 'socket'
require 'ipaddr'
require 'json'
require 'tp_link_hs110/message'

module TpLinkHs110
  class Device
    include TpLinkHs110::Message
    
    attr_accessor :address   
    attr_reader :port

    def initialize(address:, port: 9999)
      @address = IPAddr.new(address, Socket::AF_INET)
      @port = port
    end

    def info
      send(address: @address, port: @port, command: TpLinkHs110::Command::INFO)
    end

    def energy
      data = send(address: @address, port: @port, command: TpLinkHs110::Command::ENERGY)[4..]
      # JSON.parse(data)
      return data
    end
  end
end