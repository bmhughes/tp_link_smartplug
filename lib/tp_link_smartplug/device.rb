require 'socket'
require 'ipaddr'
require 'json'
require_relative 'message'

# Top level module
module TpLinkSmartplug
  # Provides an object to represent to a plug
  #
  # @author Ben Hughes
  # @attr [IPAddr] address IP address of the plug
  # @attr [Integer] port Port to connect to on the plug
  # @attr [Integer] timeout Timeout value for connecting and sending commands to the plug
  # @attr [true, false] debug Control debug logging
  class Device < TpLinkSmartplug::Base
    include TpLinkSmartplug::Helpers
    include TpLinkSmartplug::Message

    attr_accessor :address, :port, :timeout, :poll_auto_close, :auto_connect, :debug

    def initialize(address:, port: 9999, auto_connect: true, auto_disconnect: true)
      super()

      @address = IPAddr.new(address, Socket::AF_INET)
      @port = port
      @timeout = 3
      @debug = false
      @sockaddr = Addrinfo.getaddrinfo(@address.to_s, @port, Socket::PF_INET, :STREAM, 6).first.to_sockaddr
      @socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
      @poll_auto_close = auto_disconnect
      @auto_connect = auto_connect

      connect if auto_connect
    end

    # Open connection to plug
    #
    def connect
      debug_message("Connecting to #{@address} port #{@port}") if @debug
      debug_message("Connecting, socket state: #{@socket.closed? ? 'closed' : 'open'}") if @debug

      @socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM) if closed?

      begin
        @socket.connect_nonblock(@sockaddr)
        debug_message('Connected') if @debug
      rescue IO::WaitWritable
        if @socket.wait_writable(@timeout)
          begin
            @socket.connect_nonblock(@sockaddr)
          rescue Errno::EISCONN
            debug_message('Connected') if @debug
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            @socket.close
            raise TpLinkSmartplug::DeviceError, "Connection refused or host unreachable connecting to address #{@address}, port #{@port}!"
          rescue StandardError => e
            disconnect
            debug_message("Unexpected exception encountered. Error: #{e}") if @debug
            raise
          end
        else
          disconnect
          raise TpLinkSmartplug::DeviceError, "Connection timeout connecting to address #{@address}, port #{@port}."
        end
      rescue Errno::EISCONN
        debug_message('Connected') if @debug
      rescue Errno::EINPROGRESS
        debug_message('Connection in progress') if @debug
        retry
      rescue Errno::ECONNREFUSED
        raise TpLinkSmartplug::DeviceError, "Connection refused connecting to address #{@address}, port #{@port}."
      end
    end

    # Close connection to plug
    #
    def disconnect
      @socket.close unless closed?
    end

    alias_method :close, :disconnect

    # Return connection state open
    #
    # @return [True, False]
    def open?
      !@socket.closed?
    end

    # Return connection state closed
    #
    # @return [True, False]
    def closed?
      @socket.recvfrom_nonblock(0)
    rescue IO::WaitReadable
      false
    rescue Errno::ENOTCONN, IOError
      true
    end

    # Polls plug with a command
    #
    # @param command [String] the command to send to the plug
    # @return [Hash] the output from the plug command
    def poll(command:)
      connect if closed?

      begin
        debug_message("Sending: #{decrypt(encrypt(command)[4..(command.length + 4)])}") if @debug
        @socket.write_nonblock(encrypt(command))
      rescue IO::WaitWritable
        @socket.wait_writable(@timeout)
        retry
      end

      begin
        data = @socket.recv_nonblock(2048)
      rescue IO::WaitReadable
        @socket.wait_readable(@timeout)
        retry
      end

      if @poll_auto_close && !closed?
        disconnect
        raise DeviceError, 'Error occured during disconnect' unless closed?
      end

      raise DeviceError, 'No data received' if nil_or_empty?(data)

      debug_message("Received Raw: #{data.split('\\')}") if @debug
      data = decrypt(data[4..data.length])
      debug_message("Received Decrypted: #{data}") if @debug

      data
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
    # @!method timezone
    #   Return system timezone from the plug
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
    # @!method reset
    #   Reset plug
    #   @return [Hash]
    # @!method energy
    #   Return plug energy data
    #   @return [Hash]
    # @!method ledon
    #   Disable plug night mode (LED on)
    #   @return [Hash]
    # @!method ledoff
    #   Enable plug night mode (LED off)
    #   @return [Hash]
    [
      :info,
      :on,
      :off,
      :cloudinfo,
      :wlanscan,
      :time,
      :timezone,
      :schedule,
      :countdown,
      :antitheft,
      :reboot,
      :reset,
      :energy,
      :energygains,
      :ledon,
      :ledoff,
    ].each do |method|
      define_method method do
        JSON.parse(poll(command: TpLinkSmartplug::Command.const_get(method.upcase)))
      end
    end
  end

  # Set plug alias
  #
  # @param name [String] the name to assign to the plug alias
  # @return [Hash] the output from the plug command
  def alias=(name)
    JSON.parse(poll(command: "{\"system\":{\"set_dev_alias\":{\"alias\":\"#{name}\"}}}"))
  end

  # Set plug location
  #
  # @param longitude [String] the longitude to assign to the plug location
  # @param lattitude [String] the lattitude to assign to the plug location
  # @return [Hash] the output from the plug command
  def location!(longitude, lattitude)
    JSON.parse(poll(command: "{\"system\":{\"set_dev_location\":{\"longitude\":\"#{lattitude}\", \"latitude\":\"#{longitude}\"}}}"))
  end

  class DeviceError < TpLinkSmartplug::BaseError; end
end
