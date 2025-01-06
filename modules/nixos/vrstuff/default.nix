{lib, pkgs, config,...}:
{
	options.pluto.gaming.vrstuff.enable = lib.mkEnableOption "Enable VR Utils" // {default = false;};
	config = lib.mkIf config.pluto.gaming.vrstuff.enable {
		programs.envision = {
			enable = true;
			openFirewall = true; # This is set true by default
		};
		services.monado = {
			enable = true;
			defaultRuntime = true;
		};

	};
}
