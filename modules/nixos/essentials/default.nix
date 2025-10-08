{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.pluto.essentials;
in
{
  options.pluto.essentials.enable = mkEnableOption "Essentials Options" // {
    default = true;
  };
  config = mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        auto-optimise-store = true;

        trusted-users = [ "alark" ];
      };
    };
    environment.systemPackages = with pkgs; [
      #git
      #vim Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      zip
      unzip
      aria2
      curl
      xivlauncher
      tunctl
      bridge-utils
      man-pages
      man-pages-posix
      ripgrep
      fd
      comma
    ];
    documentation = {
      dev.enable = true;
      man.generateCaches = true;
    };
    environment.shells = [
      pkgs.nushell
    ];
    programs.git.enable = true;
    programs.neovim.defaultEditor = true;
    # xdg.portal = {
    #   wlr.enable = true;
    #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #   enable = true;
    #   xdgOpenUsePortal = true;
    # };
    # environment.pathsToLink = [
    #   "/share/xdg-desktop-portal"
    #   "/share/applications"
    # ];
    security.polkit.enable = true;
    programs.ssh = {
      startAgent = true;
    };
    #hardware.opentabletdriver = {
    #  enable = true;

    #};
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
