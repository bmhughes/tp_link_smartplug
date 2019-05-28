#!/usr/bin/env ruby

require_relative '../lib/tp_link_hs110.rb'

puts TpLinkHs110::VERSION
plug = TpLinkHs110::Device.new(address: '172.19.0.230')
puts plug.energy
