{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.plasma;
in
{
  options.pluto.desktop.plasma.enable = mkEnableOption "Evil Plasma" // {
    default = false;
  };
  config = mkIf cfg.enable {
    services.displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;
  };
}
