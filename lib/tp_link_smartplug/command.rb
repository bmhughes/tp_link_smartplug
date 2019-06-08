# frozen_string_literal: true

module TpLinkSmartplug
  # Module containing the static commands for the plug
  module Command
    # Plug information command
    INFO = '{"system":{"get_sysinfo":{}}}'
    # Plug output on command
    ON = '{"system":{"set_relay_state":{"state":1}}}'
    # Plug output off command
    OFF = '{"system":{"set_relay_state":{"state":0}}}'
    # Plug cloud info command
    CLOUDINFO = '{"cnCloud":{"get_info":{}}}'
    # Plug WLAN SSID scan command
    WLANSCAN = '{"netif":{"get_scaninfo":{"refresh":0}}}'
    # Plug time command
    TIME = '{"time":{"get_time":{}}}'
    # Plug schedule command
    SCHEDULE = '{"schedule":{"get_rules":{}}}'
    # Plug countdown command
    COUNTDOWN = '{"count_down":{"get_rules":{}}}'
    # Plug antitheft command
    ANTITHEFT = '{"anti_theft":{"get_rules":{}}}'
    # Plug reboot command
    REBOOT = '{"system":{"reboot":{"delay":1}}}'
    # Plug reset command
    RESET = '{"system":{"reset":{"delay":1}}}'
    # Plug energy command
    ENERGY = '{"emeter":{"get_realtime":{}}}'
  end
end
