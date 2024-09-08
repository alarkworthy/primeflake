{lib, pkgs, config, ...}:
with lib;
let
	cfg = config.pluto.essentials.screenshot;
in {
	options.pluto.essentials.screenshot.enable = mkEnableOption "Screenshot utility" // {default = config.pluto.desktop.sway.enable;};

	config = mkIf cfg.enable {
		home.packages = with pkgs; [
			slurp
			grim
		];


	};

}
