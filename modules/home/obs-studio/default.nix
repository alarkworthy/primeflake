{
	config,
	lib,
	pkgs,
	...
}:
{
	options.pluto.streaming.obs.enable = lib.mkEnableOption "Enables Obs-Studio";
	config = lib.mkIf config.pluto.streaming.obs.enable {
		programs.obs-studio = {
			enable = true;
			plugins = with pkgs.obs-studio-plugins; [
				wlrobs
				obs-backgroundremoval
				obs-pipewire-audio-capture
			];
		};
	};
}
