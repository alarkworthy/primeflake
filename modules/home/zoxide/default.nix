{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.pluto.shell.zoxide;
in
{
  options.pluto.shell.zoxide.enable = mkEnableOption "Enable Zoxide" // {
    default = config.pluto.programs.nushell.enable;
  };
  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
