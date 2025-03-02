{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.pluto.emulate;
in
{
  options.pluto.emulate.enable = mkEnableOption "Emulator Options" // {
    default = false;
  };
  config = mkIf cfg.enable {
    virtualisation = {
      waydroid.enable = false;
      #containers.enable = true;
      #podman = {
      #		enable = true;
      #	dockerCompat = true;
      #		defaultNetwork.settings = { dns_enabled = true; };
      #};

    };

    environment.systemPackages = [ pkgs.distrobox ];
  };
}
