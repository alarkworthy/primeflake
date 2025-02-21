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
    chaotic.hdr.enable = false;
    programs.gamescope = {
      capSysNice = true;
      enable = false;
    };
    programs.gamemode = {
      enable = false;
      enableRenice = true;
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
        enable = false;

      };
      protontricks = {
        #package =
        enable = true;
      };

    };

  };

}
