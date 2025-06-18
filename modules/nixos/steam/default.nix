{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.pluto.gaming.steam;
in
{
  options.pluto.gaming.steam.enable = mkEnableOption "Enable Gaming NixOS Module" // {
    default = true;
  };
  config = mkIf cfg.enable {
    #    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #             "steam"
    #             "steam-original"
    #             "steam-run"
    #             "xivlauncher"
    #           ];
    hardware.steam-hardware.enable = true;

    programs.alvr = {
      enable = false;
      openFirewall = true;
    };

    hardware.enableRedistributableFirmware = true;
    chaotic.hdr.enable = true;
    programs.gamescope = {
      capSysNice = true;
      enable = true;
    };
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
          ioprio = 0;
          inhibit_screensaver = 0;
          disable_splitlock = 1;
          softrealtime = "auto";
        };

        # Warning: GPU optimisations have the potential to damage hardware
        #gpu = {
        #  apply_gpu_optimisations = "accept-responsibility";
        #  gpu_device = 0;
        #  amd_performance_level = "vr";
        #};

        cpu = {
          parkcores = "no";
          pin_cores = "yes";

        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    #jovian = {
    #  hardware = {

    #    has.amd.gpu = true;
    # };
    #steam = {
    #  enable = true;
    #};
    #steamos = {
    #};
    #};
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extest.enable = true;
      gamescopeSession = {
        enable = true;

      };
      protontricks = {
        #package =
        enable = true;
      };

    };

  };

}
