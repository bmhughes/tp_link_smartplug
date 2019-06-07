# frozen_string_literal: true

require 'socket'
require 'tp_link_smartplug/helpers'
require 'tp_link_smartplug/message_helpers'

module TpLinkSmartplug
  # Provides methods to send and receive messages from plugs
  module Message
    include TpLinkSmartplug::Helpers
    include TpLinkSmartplug::MessageHelpers

    def poll(address:, port:, command:, timeout: 3, debug: false)
      socket = connect(address: address, port: port, timeout: timeout, debug: debug)
      STDOUT.puts(debug_message("Sending: #{decrypt(encrypt(command)[4..str.length])}")) if debug

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

      STDOUT.puts(debug_message("Received Raw: #{data}")) if debug
      data = decrypt(data[4..str.length])
      STDOUT.puts(debug_message("Received: #{data}")) if debug

      data
    end

    private

    def connect(address:, port:, timeout: 3, debug: false)
      STDOUT.puts(debug_message("Connecting to #{address} port #{port}")) if debug

      Socket.new(Socket::AF_INET, Socket::SOCK_STREAM).tap do |socket|
        sockaddr = Addrinfo.getaddrinfo(address.to_s, port, Socket::PF_INET, :STREAM, 6).first.to_sockaddr
        STDOUT.puts(debug_message("Connecting, socket closed: #{socket.closed?}")) if debug
        socket.connect_nonblock(sockaddr)
      rescue IO::WaitWritable
        if IO.select(nil, [socket], nil, timeout)
          begin
            socket.connect_nonblock(sockaddr)
          rescue Errno::EISCONN
            STDOUT.puts(debug_message('Connected')) if debug
          rescue StandardError => e
            socket.close
            STDOUT.puts(debug_message('Unexpected exception encountered.')) if debug
            raise e
          end
        else
          socket.close
          raise "Connection timeout connecting to address #{address}, port #{port}."
        end
      end
    end

    def disconnect(socket:)
      socket.close unless socket.closed? || socket.nil?
    end
  end
end
