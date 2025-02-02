{lib,pkgs,config,...}:
{
	options.pluto.gaming.wivr.enable = lib.mkEnableOption "Enable wivrn NixOS mdoule" // {default = false;};
	config = lib.mkIf config.pluto.gaming.wivr.enable {
		services.wivrn = {
			enable = true;
			#autoStart = true;
			defaultRuntime = true;
			openFirewall = true;
			monadoEnvironment = {
				XRT_COMPOSITOR_COMPUTE= "1";
				IPC_EXIT_ON_DISCONNECT = "0";
  			XRT_COMPOSITOR_LOG = "debug";
  			XRT_PRINT_OPTIONS = "1";
				U_PACING_COMP_MIN_TIME_MS = "9";
			};
			config = {
				enable = true;
				json = {
					#scale = 1.0;
					bitrate = 100000000;
					#encoders = [
					#	{
					#		encoder = "vaapi";
					#		codec = "av1";
					#		width = 1.0;
					#		height = 1.0;
					#		offset_x = 0.0;
					#		offset_y = 0.0;
					#	}
					#];
				};
			};
		};
	};
}
