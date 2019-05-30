# frozen_string_literal: true

module TpLinkSmartplug
  module Command
    INFO = '{"system":{"get_sysinfo":{}}}'
    ON = '{"system":{"set_relay_state":{"state":1}}}'
    OFF = '{"system":{"set_relay_state":{"state":0}}}'
    CLOUDINFO = '{"cnCloud":{"get_info":{}}}'
    WLANSCAN = '{"netif":{"get_scaninfo":{"refresh":0}}}'
    TIME = '{"time":{"get_time":{}}}'
    SCHEDULE = '{"schedule":{"get_rules":{}}}'
    COUNTDOWN = '{"count_down":{"get_rules":{}}}'
    ANTITHEFT = '{"anti_theft":{"get_rules":{}}}'
    REBOOT = '{"system":{"reboot":{"delay":1}}}'
    RESET = '{"system":{"reset":{"delay":1}}}'
    ENERGY = '{"emeter":{"get_realtime":{}}}'
  end
end
