{lib, config, pkgs, ... }:
with lib;
let cfg = config.pluto.web.firefox;
in
{
  options.pluto.web.firefox.enable = mkEnableOption "Enable Firefox" // {default = true;};
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };

}
