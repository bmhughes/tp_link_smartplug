require 'socket'
require 'tp_link_hs110/helpers'
require 'tp_link_hs110/message_helpers'

module TpLinkHs110
  module Message
    include TpLinkHs110::Helpers
    include TpLinkHs110::MessageHelpers

    def send(address:, port:, command:, timeout: 3, debug: false)
      sockaddr = Addrinfo.getaddrinfo(address.to_s, port, Socket::PF_INET, :STREAM, 6).first.to_sockaddr
      
      sock = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
      begin
        sock.connect_nonblock(sockaddr)
      rescue IO::WaitWritable
        if IO.select(nil, [sock], nil, timeout)
          begin
            sock.connect_nonblock(sockaddr)
          rescue Errno::EISCONN
            # Socket is connected, continue.
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

      begin
        sock.write(encrypt(command))
        data = sock.recv_nonblock(2048)
      rescue IO::WaitReadable
        IO.select([sock], nil, nil, timeout)
        retry
      rescue StandardError => e
        STDERR.puts(debug_message("Error occurred sending command. Exception: #{e}"))
      ensure
        sock.close
      end
      raise if data.nil?
      data = decrypt(data)
    end
  end
end