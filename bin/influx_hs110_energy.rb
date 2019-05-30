#!/usr/bin/env ruby

require 'tp_link_smartplug'
require 'time'

config = {
  'GBMDS-HS110-GARAGE-AC' => {
    'address' => '172.19.0.230',
  }
}

config.each do |name, config|
  data = TpLinkSmartplug::Device.new(address: config['address']).energy

  measurement_string = ''
  measurement_string.concat(name)
  measurement_string.concat(config['tags'].to_s) unless config['tags'].nil?
  measurement_string.concat(' ')

  {
    'voltage': 'voltage_mv',
    'current': 'current_ma',
    'power': 'power_mw',
  }.each do |field, field_value|
    measurement_string.concat("#{field}=#{data['emeter']['get_realtime'][field_value]}i")
  end

  state = -1
  if data['emeter']['get_realtime']['power_mw'] <= 100000
    state = 0
  elsif data['emeter']['get_realtime']['power_mw'] > 100000
    state = 1
  end
  measurement_string.concat("state=#{state}i")

  measurement_string.concat(' ')
  measurement_string.concat(Time.now.strftime('%Y-%m-%dT%H:%M:%S.%8NZ'))

  puts(measurement_string)
end
