{
  pkgs,
  inputs,
  config,
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
  pluto.home.system = "Laptop";
  home.packages = [
    pkgs.moonlight-qt
  ];

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
