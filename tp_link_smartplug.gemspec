# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'tp_link_smartplug'
  spec.version     = '0.0.1'
  spec.summary     = 'TP-Link HS100/110 Smart Plug interaction library'
  spec.description = 'Control and retrieve data from a TP-Link HS100/110 (Metered) Smartplug'
  spec.authors     = ['Ben Hughes']
  spec.email       = 'bmhughes@bmhughes.co.uk'
  spec.files       = Dir.glob('./lib/**/*.rb')
  spec.license     = 'Apache-2.0'
end
