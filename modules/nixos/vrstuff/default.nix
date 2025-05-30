{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.pluto.gaming.vrstuff.enable = lib.mkEnableOption "Enable VR Utils" // {
    default = false;
  };
  config = lib.mkIf config.pluto.gaming.vrstuff.enable {

    environment.systemPackages = with pkgs; [
      slimevr-server
      #slimevr
    ];
    networking.firewall = {
      allowedTCPPorts = [
        21110
      ];
      allowedUDPPorts = [
        35903
        6969
      ];
    };
    services.udev.packages = [
      pkgs.platformio-core
      pkgs.openocd
    ];
    #programs.git.lfs.enable = true;

    #services.pipewire = {
    #  wireplumber.extraConfig."99-disable-suspend" = {
    #    "monitor.alsa.rules" = [
    #      {
    #        matches = [
    #          {
    #            "node.name" = "wivrn.sink";
    # #          }
    #           ];
    #           actions = {
    #             update-props = {
    #               "session.suspend-timeout-seconds" = 0;
    #               "api.alsa.period-size" = 1024;
    #               "api.alsa.headroom" = 8192;
    #             };
    #           };
    #         }
    #       ];
    #     };
      # };
    boot.kernelPatches = [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];
  };
}
