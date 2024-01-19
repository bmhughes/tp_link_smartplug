module TpLinkSmartplug
  # Module containing the static commands for the plug
  module Command
    # Plug information command
    INFO = '{"system":{"get_sysinfo":{}}}'.freeze
    # Plug output on command
    ON = '{"system":{"set_relay_state":{"state":1}}}'.freeze
    # Plug output off command
    OFF = '{"system":{"set_relay_state":{"state":0}}}'.freeze
    # Plug cloud info command
    CLOUDINFO = '{"cnCloud":{"get_info":{}}}'.freeze
    # Plug WLAN SSID scan command
    WLANSCAN = '{"netif":{"get_scaninfo":{"refresh":0}}}'.freeze
    # Plug time command
    TIME = '{"time":{"get_time":{}}}'.freeze
    # Plug timezone command
    TIMEZONE = '{"time":{"get_timezone":{}}}'.freeze
    # Plug schedule command
    SCHEDULE = '{"schedule":{"get_rules":{}}}'.freeze
    # Plug countdown command
    COUNTDOWN = '{"count_down":{"get_rules":{}}}'.freeze
    # Plug antitheft command
    ANTITHEFT = '{"anti_theft":{"get_rules":{}}}'.freeze
    # Plug reboot command
    REBOOT = '{"system":{"reboot":{"delay":1}}}'.freeze
    # Plug reset command
    RESET = '{"system":{"reset":{"delay":1}}}'.freeze
    # Plug energy command
    ENERGY = '{"emeter":{"get_realtime":{}}}'.freeze
    # Plug energy VGain/IGain settings
    ENERGYGAINS = '{"emeter":{"get_vgain_igain":{}}}'.freeze
    # Plug LED On
    LEDON = '{"system":{"set_led_off":{"off":0}}}'.freeze
    # Plug LED Off
    LEDOFF = '{"system":{"set_led_off":{"off":1}}}'.freeze
  end
end
