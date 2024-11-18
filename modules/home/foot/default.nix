{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.pluto.essentials.foot;
in
{
  options.pluto.essentials.foot.enable = mkEnableOption "Enable Foot" // {
    default = true;
  };
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
    };
  };
}
