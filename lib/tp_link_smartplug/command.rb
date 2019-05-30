module TpLinkSmartplug
  module Command
    INFO = '{"system":{"get_sysinfo":{}}}'.freeze
    ON = '{"system":{"set_relay_state":{"state":1}}}'.freeze
    OFF = '{"system":{"set_relay_state":{"state":0}}}'.freeze
    CLOUDINFO = '{"cnCloud":{"get_info":{}}}'.freeze
    WLANSCAN = '{"netif":{"get_scaninfo":{"refresh":0}}}'.freeze
    TIME = '{"time":{"get_time":{}}}'.freeze
    SCHEDULE =  '{"schedule":{"get_rules":{}}}'.freeze
    COUNTDOWN = '{"count_down":{"get_rules":{}}}'.freeze
    ANTITHEFT = '{"anti_theft":{"get_rules":{}}}'.freeze
    REBOOT = '{"system":{"reboot":{"delay":1}}}'.freeze
    RESET = '{"system":{"reset":{"delay":1}}}'.freeze
    ENERGY =  '{"emeter":{"get_realtime":{}}}'.freeze
  end
end