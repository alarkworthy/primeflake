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
  #pluto.texLive.enable = true;
  pluto.ssh.client.enable = true;
  pluto.desktop.swaylock = {
    enable = true;
    idle = {
      enable = true;
    };
  };
  pluto.home.system = "Laptop";
	pluto.desktop.thunderbird.enable = true;
  home.packages = [
    pkgs.moonlight-qt
  ];
}
