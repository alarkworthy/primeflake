{lib,config,pkgs,...}:
with lib;
let cfg = config.pluto.essential.git;
in
{
  options.pluto.essential.git.enable = mkEnableOption "Enable Git HomeManager" // {default = true;};
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Andrew Larkworthy";
      userEmail = "andrew@larkworthy.org";
      };
  };
}
