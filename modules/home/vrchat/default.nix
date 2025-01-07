{ config, pkgs, lib,...}:
{
	options.pluto.vr.vrchat.enable = lib.mkEnableOption "Enable VRChat SDK Stuff" // {default = false;};
	config = lib.mkIf config.pluto.vr.vrchat.enable {
		home.packages = with pkgs; [
			vrc-get
			unityhub
			alcom
			wlx-overlay-s
		];
		xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
	};
}
