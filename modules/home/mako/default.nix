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
    services.mako = {
      enable = true;
      defaultTimeout = 10000;
      borderSize = 3;
      borderRadius = 5;
			#anchor = "top-left";
			#output = "DP-1";
      layer = "overlay";
    } // (mkIf (config.pluto.home.system == "Desktop") 
				{
					defaultTimeout = 5000;
					anchor = "top-left";
					output = "DP-1";
				})
			// (mkIf (config.pluto.home.system == "Laptop") 
				{
					anchor = "top-right";
				}
			);
  };
}
