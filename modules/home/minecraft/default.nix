{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.gaming.minecraft;
in
{
  options.pluto.gaming.minecraft.enable = mkEnableOption "Enable Minecraft" // {
    default = true;
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
			zenity
			prismlauncher
			(mcpelauncher-ui-qt .overrideAttrs (prev: {
				runtimeDeps = [pkgs.zenity];
			}) )
    ];
  };
}
