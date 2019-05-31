# tp_link_smartplug

Ruby gem to retrieve data and control a TP Link HS100/HS110 smart plug.

[![Build Status](https://gitlab.bmhughes.co.uk/bmhughes/tp_link_smartplug/badges/master/build.svg)](https://gitlab.bmhughes.co.uk/bmhughes/tp_link_smartplug) [![Coverage Report](https://gitlab.bmhughes.co.uk/bmhughes/tp_link_smartplug/badges/master/coverage.svg)](https://gitlab.bmhughes.co.uk/bmhughes/tp_link_smartplug/commits/master)

## bin

### influx_hs110_energy.rb

Outputs smart plug data in the InfluxDB line data format. For use with the **telegraf** *exec* input plugin.
