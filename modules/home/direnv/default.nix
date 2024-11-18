{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.shell.direnv;
in
{
  options.pluto.shell.direnv.enable =
    mkEnableOption "Shell extension that manages your environment"
    // {
      default = true;
    };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
