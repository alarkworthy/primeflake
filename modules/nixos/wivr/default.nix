{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.pluto.gaming.wivr.enable = lib.mkEnableOption "Enable wivrn NixOS mdoule" // {
    default = false;
  };
  config = lib.mkIf config.pluto.gaming.wivr.enable {
    services.wivrn = {
      enable = true;
      autoStart = false;
			package = pkgs.wivrn;
			extraPackages = [ pkgs.bash pkgs.procps pkgs.android-tools ];
      defaultRuntime = true;
      openFirewall = true;
      monadoEnvironment = {
				XRT_COMPOSITOR_COMPUTE = "1";
        IPC_EXIT_ON_DISCONNECT = "0";
				#XRT_COMPOSITOR_LOG = "debug";
				#XRT_PRINT_OPTIONS = "1";
				U_PACING_COMP_MIN_TIME_MS = "8";
				#U_PACING_APP_USE_MIN_FRAME_PERIOD = "1";
				XRT_COMPOSITOR_DEFAULT_FRAMERATE="120";
				#XRT_CURATED_GUI = "1";
				#XRT_DEBUG_GUI = "1";
      };
      config = {
        enable = true;
        json = {
          scale = [0.75 0.75];
          bitrate = 50000000;
					encoders = [
						{
							encoder = "vaapi";
							codec = "h265";
							width = 0.5;
							height = 0.25;
							offset_x = 0.0;
							offset_y = 0.0;
						}
						{
							encoder = "vaapi";
							codec = "h265";
							width = 0.5;
							height = 0.75;
							offset_x = 0.0;
							offset_y = 0.25;
						}
						{
							encoder = "vaapi";
							codec = "h265";
							width = 0.5;
							height = 1.0;
							offset_x = 0.5;
							offset_y = 0.0;
						}
					];
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
