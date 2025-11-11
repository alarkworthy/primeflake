{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  #Enable modules
  pluto.home-manager.enable = true;
  pluto.desktop.sway.enable = true;
  pluto.emulation.rars.enable = true;
  pluto.texLive.enable = true;
  pluto.ssh.client.enable = true;
  pluto.desktop.swaylock = {
    enable = true;
    idle = {
      enable = false;
    };
  };
  pluto.containers.distrobox = {
    enable = true;
    matlab = true;
  };
  chaotic.nyx.nixPath.enable = false;
  # environment.sessionVariables.NIX_PATH = lib.mkForce "nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels";

  # Prevent NixOS from appending any other channel entries
  nix.nixPath = lib.mkForce [
    "nixpkgs=flake:nixpkgs"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  pluto.home.system = "Laptop";
  home.packages = [
    pkgs.moonlight-qt
    pkgs.mprisence
    pkgs.vlc
  ];

  programs = {
    yazi = {
      enable = true;
      enableNushellIntegration = true;
      extraPackages = [
        pkgs.ouch
        pkgs.glow
      ];
      settings = {
        log = false;
      };
    };
    mpv = {
      enable = true;
      scripts = [ pkgs.mpvScripts.mpris ];
    };
  };

  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications =
  #     let
  #       qute = "org.qutebrowser.qutebrowser.desktop";
  #     in
  #     {
  #       "text/html" = qute;
  #       "x-scheme-handler/http" = qute;
  #       "x-scheme-handler/https" = qute;
  #       "x-scheme-handler/about" = qute;
  #       "x-scheme-handler/unknown" = qute;
  #     };
  # };
}
