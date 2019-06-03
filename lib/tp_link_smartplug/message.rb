# frozen_string_literal: true

require 'socket'
require 'tp_link_smartplug/helpers'
require 'tp_link_smartplug/message_helpers'

module TpLinkSmartplug
  # Provides methods to send and receive messages from plugs
  module Message
    include TpLinkSmartplug::Helpers
    include TpLinkSmartplug::MessageHelpers

    # Sends a message to a smart plug and receives the result
    #
    # @address [IPAddr] the IP address for the smart plug
    # @port [Integer] the port to connect to for the smart plug
    # @command [String] the raw message to be send to the smart plug
    # @timeout [Integer] the time to wait when connecting or sending a message before a timeout occurs
    # @debug [TrueClass, FalseClass] enable debug logging output
    def send(address:, port:, command:, timeout: 3, debug: false)
      sockaddr = Addrinfo.getaddrinfo(address.to_s, port, Socket::PF_INET, :STREAM, 6).first.to_sockaddr
      STDOUT.puts(debug_message("Will connect to #{address} port #{port}")) if debug

      sock = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
      begin
        STDOUT.puts(debug_message('Connecting')) if debug
        sock.connect_nonblock(sockaddr)
      rescue IO::WaitWritable
        if IO.select(nil, [sock], nil, timeout)
          begin
            sock.connect_nonblock(sockaddr)
          rescue Errno::EISCONN
            # Socket is connected, continue.
            STDOUT.puts(debug_message('Connected')) if debug
          rescue StandardError => e
            # Unexpected exception
            sock.close
            raise e
          end
        else
          sock.close
          raise "Connection timeout connecting to address #{address}, port #{port}."
        end
      end

      STDOUT.puts(debug_message("Sending: #{decrypt(encrypt(command)[4..])}")) if debug
      sock.write(encrypt(command))

      begin
        data = sock.recv_nonblock(2048)
      rescue IO::WaitReadable
        IO.select([sock])
        retry
      ensure
        sock.close
      end

      raise 'No data received' if data.nil? || data.empty?

      STDOUT.puts(debug_message("Received Raw: #{data}")) if debug
      data = decrypt(data[4..])
      STDOUT.puts(debug_message("Received: #{data}")) if debug
      data
    end
  end
end
