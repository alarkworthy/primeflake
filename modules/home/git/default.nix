{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.essential.git;
in
{
  options.pluto.essential.git.enable = mkEnableOption "Enable Git HomeManager" // {
    default = true;
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Andrew Larkworthy";
        email = "andrew@larkworthy.org";
      };
    };
  };
}
