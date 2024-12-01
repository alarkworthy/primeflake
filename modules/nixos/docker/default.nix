{ config, lib, ... }:
with lib;
let
  cfg = config.pluto.docker;
in
{
  options.pluto.docker.enable = mkEnableOption "Docker Support" // {
    default = false;
  };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      storageDriver = "btrfs";

    };

  };
}
