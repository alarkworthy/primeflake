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
		xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";

		xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  {
    "config" :
    [
      "${config.xdg.dataHome}/Steam/config"
    ],
    "external_drivers" : null,
    "jsonid" : "vrpathreg",
    "log" :
    [
      "${config.xdg.dataHome}/Steam/logs"
    ],
    "runtime" :
    [
      "${pkgs.opencomposite-vendored}/lib/opencomposite"
    ],
    "version" : 1
  }
'';
		#xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
	};
}
