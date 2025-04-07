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
    programs.ssh = mkMerge [
      {
        enable = true;
        addKeysToAgent = "yes";
      }
      (mkIf (config.pluto.home.system == "Desktop") {
        matchBlocks = {
          "alark.server.local" = {
            host = "alark.server";
            hostname = "192.168.50.218";
            user = "alark";
            identityFile = "/home/alark/.ssh/id_ed25519";
            identitiesOnly = true;
          };
          "alark.github" = {
            host = "alark.github";
            hostname = "github.com";
            user = "git";
            identityFile = "/home/alark/.ssh/id_ed25519";
            identitiesOnly = true;
          };
        };
      })
    ];
  };
}
