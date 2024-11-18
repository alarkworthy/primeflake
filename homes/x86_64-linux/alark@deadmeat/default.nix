{ inputs, config, ... }:
{
  #Enable modules
  pluto.home-manager.enable = true;
  pluto.desktop.sway.enable = true;
  pluto.texLive.enable = true;
  pluto.ssh.client.enable = true;
}
