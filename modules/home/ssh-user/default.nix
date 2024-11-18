{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.pluto.ssh.client;
in
{
  options.pluto.ssh.client.enable = mkEnableOption "Enable SSH Client Options" // {
    default = false;
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "confirm";

    };
  };
}
