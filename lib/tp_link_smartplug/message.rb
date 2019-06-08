# frozen_string_literal: true

require 'socket'
require 'tp_link_smartplug/helpers'
require 'tp_link_smartplug/message_helpers'

module TpLinkSmartplug
  # Provides methods to send and receive messages from plugs
  module Message
    include TpLinkSmartplug::Helpers
    include TpLinkSmartplug::MessageHelpers

    # Polls a plug with a command
    #
    # @param address [IPAddr] ipaddr object for the IP address of the plug
    # @param port [Integer] integer value of the port to connect to on the plug
    # @param command [String] the command to send to the plug
    # @param timeout [Integer] the value in seconds before a timeout occurs when accessing a plug
    # @param debug [true, false] control debug logging output
    # @return [String] the output from the plug command
    def poll(address:, port:, command:, timeout: 3, debug: false)
      socket = connect(address: address, port: port, timeout: timeout, debug: debug)
      debug_message("Sending: #{decrypt(encrypt(command)[4..(command.length + 4)])}") if debug

      begin
        socket.write_nonblock(encrypt(command))
        data = socket.recv_nonblock(2048)
      rescue IO::WaitReadable, IO::WaitWritable
        IO.select([socket], [socket])
        retry
      ensure
        disconnect(socket: socket)
      end

      raise 'Error occured during disconnect' unless socket.closed?
      raise 'No data received' if data.nil? || data.empty?

      debug_message("Received Raw: #{data}") if debug
      data = decrypt(data[4..data.length])
      debug_message("Received Decrypted: #{data}") if debug

      data
    end

    private

    # Connect to a plug
    #
    # @param address [IPAddr] ipaddr object for the IP address of the plug
    # @param port [Integer] integer value of the port to connect to on the plug
    # @param timeout [Integer] the value in seconds before a timeout occurs when accessing a plug
    # @param debug [true, false] control debug logging output
    # @return [Socket] socket object for the plug connection
    def connect(address:, port:, timeout: 3, debug: false)
      debug_message("Connecting to #{address} port #{port}") if debug

      Socket.new(Socket::AF_INET, Socket::SOCK_STREAM).tap do |socket|
        sockaddr = Addrinfo.getaddrinfo(address.to_s, port, Socket::PF_INET, :STREAM, 6).first.to_sockaddr
        debug_message("Connecting, socket state: #{socket.closed? ? 'closed' : 'open'}") if debug
        socket.connect_nonblock(sockaddr)
      rescue IO::WaitWritable
        if IO.select(nil, [socket], nil, timeout)
          begin
            socket.connect_nonblock(sockaddr)
          rescue Errno::EISCONN
            debug_message('Connected') if debug
          rescue StandardError => e
            socket.close
            debug_message('Unexpected exception encountered.') if debug
            raise e
          end
        else
          socket.close
          raise "Connection timeout connecting to address #{address}, port #{port}."
        end
      end
    end

    # Disconnect from a plug
    #
    # @param socket [Socket] socket object to disconnect
    # @return [Socket] socket object for the plug connection
    def disconnect(socket:)
      socket.close unless socket.closed? || socket.nil?
    end
  end
end
