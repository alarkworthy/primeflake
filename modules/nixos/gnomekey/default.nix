{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.pluto.essential.gnomekeyring;
in
{
  options.pluto.essential.gnomekeyring.enable = mkEnableOption "Enable Gnome Key Ring" // {
    default = false;
  };
  config = mkIf cfg.enable {
    services.gnome.gnome-keyring = {
      enable = true;
    };
    services.gnome.gcr-ssh-agent.enable = false;
    # environment.systemPackages = [ pkgs.gnome-keyring ];
    # security.pam.services.sway.enableGnomeKeyring = true;
    # security.pam.services.login.enableGnomeKeyring = true;
  };
}
