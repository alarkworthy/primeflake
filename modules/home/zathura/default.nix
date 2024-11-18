{config, lib,...}:
with lib;
let cfg = config.pluto.desktop.zathura;
in 
{
	options.pluto.desktop.zathura.enable = mkEnableOption "Enable Zathura" // {default = true;};

	config = mkIf cfg.enable {
		zathura = {
			enable = true;
		};

	};
}
