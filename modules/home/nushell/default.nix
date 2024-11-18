{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.programs.nushell;
in
{
  options.pluto.programs.nushell.enable = mkEnableOption "Enable Nushell" // {
    default = true;
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.vivid ];
    programs = {
      nushell = {
        enable = true;
        configFile.source = ./config.nu;
        envFile.source = ./env.nu;
        shellAliases = {
          "tree" = "lsd --tree";
          "gensokyo" = "mpg123 https://stream.gensokyoradio.net/1/";
        };

      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      lsd.enable = true;
      fzf = {
        enable = true;
      };
    };
  };
}
