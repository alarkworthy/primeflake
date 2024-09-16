{ config, lib, pkgs, ...}:

with lib;
let
  cfg = config.pluto.essentials;
in {
  options.pluto.essentials.enable = mkEnableOption "Essentials Options" // {
    default = true;
  };
  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nixFlakes;
      settings = {
        experimental-features = ["nix-command" "flakes"];
  
        auto-optimise-store = true;
  
        trusted-users = ["alark"];
      };
    };
    environment.systemPackages = with pkgs; [
    	#git
    	#vim Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	wget
        quickemu
	curl
        xivlauncher
        tunctl
        bridge-utils
    ];
    programs.git.enable = true;
    programs.neovim.defaultEditor = true;
    environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
    security.polkit.enable = true;
    hardware.opentabletdriver = {
      enable = true;

    };
    #services.xserver = {
    #  enable = true;
    #  autorun = false;
    #  videoDrivers = [
    #    "amdgpu"
    #    "modesetting"
    #    "fbdev"
    #
    #  ];
    #  };
    #services.xserver.displayManager = {
    #startx.enable = true;
    #};
  };
}
