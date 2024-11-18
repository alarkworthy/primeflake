{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.clipman;
in
{
  options.pluto.desktop.clipman.enable = mkEnableOption "Enable Clipman" // {
    default = config.pluto.desktop.sway.enable;
  };
  config = mkIf cfg.enable {
    #services.clipman = {
    #  enable = true;
    #  systemdTarget = "sway-session.target";
    #};
    home.packages = with pkgs; [
      wl-clipboard
    ];

  };
}
