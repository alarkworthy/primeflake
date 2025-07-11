{ inputs, config, ... }:
{
  #Enable modules
  pluto.home-manager.enable = true;
  pluto.desktop.sway.enable = true;
  pluto.emulation.rars.enable = true;
  pluto.texLive.enable = true;
  pluto.ssh.client.enable = true;
  pluto.home.system = "Desktop";
  pluto.streaming.obs.enable = true;
  pluto.vr.vrchat.enable = true;
  pluto.sound.design.enable = true;
}
