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
			enable = true;
			openFirewall = true;
		};



    hardware.enableRedistributableFirmware = true;
    chaotic.hdr.enable = false;
    programs.gamescope = {
      capSysNice = true;
      enable = true;
    };
    programs.gamemode = {
      enable = true;
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
        enable = true;

      };
      protontricks = {
        #package =
        enable = true;
      };

    };

  };

}
