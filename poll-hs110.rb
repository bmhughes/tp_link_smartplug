#! /usr/bin/env ruby

require 'json'
require 'socket'
require 'time'

def debug_message(string)
  Time.now.strftime('%Y-%m-%d %H:%M:%S: ').concat(string)
end

def encrypt(string)
  _key = 171
  _result = [30].pack('N')
  string.each_char do |char|
    _key = _a = _key ^ char.ord
    _result.concat(_a.chr)
  end
  return _result
end

def decrypt(string)
  _key = 171
  _result = ''
  string.each_char do |char|
    _a = _key ^ char.ord
    _key = char.ord
    _result.concat(_a.chr)
  end
  return _result
end

def send_command(address:, port:, command:)
  _tcp_socket = TCPSocket::new(address, port)
  data = nil

  begin
    _tcp_socket.write(encrypt(command))    
    data = _tcp_socket.recv(2048)
  rescue StandardError => e
    STDERR.puts(debug_message("Error occurred! Exception: #{e}"))
  ensure
    _tcp_socket.close
  end
  
  return data
end

def return_measurement(name:, tags: nil, data:)
  _data = JSON.parse(data)

  _measurement_string = ''
  _measurement_string.concat(name)
  _measurement_string.concat(tags.to_s) unless tags.nil?
  _measurement_string.concat(' ')
  
  {
    'voltage': 'voltage_mv',
    'current': 'current_ma',
    'power': 'power_mw',
  }.each do |field, field_value|
    _measurement_string.concat("#{field}=#{_data['emeter']['get_realtime'][field_value]}i")
  end
  
  _measurement_string.concat(' ')
  _measurement_string.concat(Time.now.strftime('%Y-%m-%dT%H:%M:%S.%8NZ'))

  return _measurement_string
end

config = {
  'GBMDS-HS110-GARAGE-AC' => {
    'address' => '172.19.0.230',
    'port' => 9999,
  }
}

config.each do |name, config|
  puts return_measurement(name: name, data: (decrypt(send_command(address: config['address'], port: config['port'], command: '{"emeter":{"get_realtime":{}}}')[4..])))
end
