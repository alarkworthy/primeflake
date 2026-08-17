{ pkgs, ... }:
{
  #Enable modules
  pluto.home-manager.enable = true;
  pluto.desktop.sway.enable = true;
  pluto.emulation.rars.enable = true;
  # pluto.texLive.enable = true;
  pluto.ssh.client.enable = true;
  pluto.home.system = "Desktop";
  pluto.streaming.obs.enable = true;
  pluto.vr.vrchat.enable = true;
  pluto.sound.design.enable = false;

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
  };

  home.packages = [
    pkgs.spotify
  ];

  programs.distrobox = {
    enable = true;
  };

  programs.calibre = {
    enable = true;
  };

  # programs.sm64ex = {
  #   baserom = /home/alark/Games/old/n64/mario/baserom.us.z64;
  #   enable = true;
  # };
}
