{lib,pkgs,config,...}:
with lib;
let cfg = config.pluto.streaming.sunshine;
in
{
  options.pluto.streaming.sunshine.enable = mkEnableOption "Sunshine Game Streaming Server" // {default = false;};
  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      

    };
  };
}


