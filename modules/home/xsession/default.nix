{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.xsession;
in
{
  options.pluto.desktop.xsession.enable = mkEnableOption "Enable X and i3" // {
    default = false;
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dmenu
    ];
    xsession = {
      enable = true;
      windowManager = {
        i3 = {
          enable = true;

        };
      };
    };

  };

}
