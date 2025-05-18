{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.mako;
in
{
  options.pluto.desktop.mako.enable = mkEnableOption "Enable Mako" // {
    default = config.pluto.desktop.sway.enable;
  };
  config = mkIf cfg.enable {
    services.mako =
      {
        enable = true;
        settings =
      
      {
        default-timeout = "10000";
        anchor = "top-left";
        border-size = "3";
        border-radius = "5";
        output = "DP-1";
        layer = "overlay";
      }
      ;
      };
      #     // attrsets.optionalAttrs (config.pluto.home.system == "Desktop") {
      #   defaultTimeout = 5000;
      #   output = "DP-1";
      # }
      # // attrsets.optionalAttrs (config.pluto.home.system == "Laptop") {
      #   anchor = "top-right";
      # };
  };
}
