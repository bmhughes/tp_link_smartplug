# tp_link_smartplug

Ruby gem to retrieve data and control a TP Link HS100/HS110 smart plug.

![Release](https://img.shields.io/github/release/bmhughes/tp_link_smartplug.svg) [![Build Status](https://travis-ci.org/bmhughes/tp_link_smartplug.svg?branch=master)](https://travis-ci.org/bmhughes/tp_link_smartplug) ![License](https://img.shields.io/github/license/bmhughes/tp_link_smartplug.svg)

## References

Thanks for the following sources for the information required to make this gem.

- https://www.softscheck.com/en/reverse-engineering-tp-link-hs110/
- https://www.beardmonkey.eu/tplink/hs110/2017/11/21/collect-and-store-realtime-data-from-the-tp-link-hs110.html

## Change Log

- See [CHANGELOG.md](/CHANGELOG.md) for version details and changes.

## bin

### influx_hs110_energy.rb

Outputs smart plug data in the InfluxDB line data format. For use with the **telegraf** *exec* input plugin.
