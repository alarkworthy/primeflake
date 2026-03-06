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
    environment.systemPackages = [
      pkgs.bash
      pkgs.procps
      pkgs.xrizer
    ];
    systemd.user.services.wivrn.serviceConfig.ExecStart =
      lib.mkForce "${config.security.wrapperDir}/wivrn-server";
    services.wivrn = {
      enable = true;
      autoStart = false;
      package = pkgs.wivrn;
      highPriority = true;
      #pkgs.alarkPkgs.wivrn-solarXR;
      defaultRuntime = true;
      openFirewall = true;
      monadoEnvironment = {
        # XRT_COMPOSITOR_COMPUTE = "1";
        #IPC_EXIT_ON_DISCONNECT = "0";
        #XRT_COMPOSITOR_LOG = "debug";
        #XRT_PRINT_OPTIONS = "1";
        # U_PACING_COMP_MIN_TIME_MS = "5";
        #U_PACING_APP_USE_MIN_FRAME_PERIOD = "1";
        #XRT_COMPOSITOR_DEFAULT_FRAMERATE="120";
        #AMD_VULKAN_ICD = "RADV";
        #XRT_CURATED_GUI = "1";
        #XRT_DEBUG_GUI = "1";
      };
      config = {
        enable = false;
        json = {
          scale = 0.5;
          # bitdepth = 10;
          bitrate = 50000000;
          #   45000000;
          # encoders = [
          #   {
          #     codec = "h265";
          #     encoder = "vulkan";
          #     width = 0.5;
          #   }
          #   {
          #     codec = "h265";
          #     encoder = "vulkan";
          #     offset_x = 0.5;
          #     width = 0.5;
          #   }
          # ];
          # encoders = [
          #   {
          #     encoder = "vaapi";
          #     codec = "h265";
          #     width = 0.5;
          #     height = 0.25;
          #     offset_x = 0.0;
          #     offset_y = 0.0;
          #   }
          #   {
          #     encoder = "vaapi";
          #     codec = "h265";
          #     width = 0.5;
          #     height = 0.75;
          #     offset_x = 0.0;
          #     offset_y = 0.25;
          #   }
          #   {
          #     encoder = "vaapi";
          #     codec = "h265";
          #     width = 0.5;
          #     height = 1.0;
          #     offset_x = 0.5;
          #     offset_y = 0.0;
          #   }
          # ];
          openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
          # application = [ pkgs.wlx-overlay-s ];
        };
      };
    };
  };
}
