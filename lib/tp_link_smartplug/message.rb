require 'socket'
require 'tp_link_smartplug/helpers'
require 'tp_link_smartplug/message_helpers'

module TpLinkSmartplug
  module Message
    include TpLinkSmartplug::Helpers
    include TpLinkSmartplug::MessageHelpers

    def send(address:, port:, command:, timeout: 3, debug: false)
      sockaddr = Addrinfo.getaddrinfo(address.to_s, port, Socket::PF_INET, :STREAM, 6).first.to_sockaddr
      STDOUT.puts(debug_message("Will connect to #{address.to_s} port #{port.to_s}")) if debug
      
      sock = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
      begin
        STDOUT.puts(debug_message("Connecting")) if debug
        sock.connect_nonblock(sockaddr)
      rescue IO::WaitWritable
        if IO.select(nil, [sock], nil, timeout)
          begin
            sock.connect_nonblock(sockaddr)
          rescue Errno::EISCONN
            # Socket is connected, continue.
            STDOUT.puts(debug_message("Connected")) if debug
          rescue StandardError => e
            # Unexpected exception
            sock.close
            raise e
          end
        else
          sock.close
          raise "Connection timeout connecting to address #{address.to_s}, port #{port.to_s}."
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