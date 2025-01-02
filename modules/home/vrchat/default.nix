{ config, pkgs, lib,...}:
{
	options.pluto.vr.vrchat.enable = lib.mkEnableOption "Enable VRChat SDK Stuff" // {default = false;};
	config = lib.mkIf config.pluto.vr.vrchat.enable {
		home.packages = with pkgs; [
			vrc-get
			unityhub
			alcom
		];
	};
}
