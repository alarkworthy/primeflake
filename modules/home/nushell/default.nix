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
    # programs.home-manager.userShell = pkgs.nushell;
    programs = {
      bash = {
        enable = true;
        enableVteIntegration = true;
        shellAliases = {
          "tree" = "lsd --tree";
          "gensokyo" = "mpg123 https://stream.gensokyoradio.net/1/";
          ".." = "cd ..";

        };
        sessionVariables = {
          WLR_RENDERER = "vulkan";
        };
      };
      nushell = {
        enable = true;
        configFile.source = ./config.nu;
        # environmentVariables = config.home.sessionVariables;
        envFile.source = ./env.nu;
        shellAliases = config.home.shellAliases // {
          "tree" = "lsd --tree";
          "gensokyo" = "mpg123 https://stream.gensokyoradio.net/1/";
        };

      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
        enableBashIntegration = true;
      };
      lsd.enable = true;
      fzf = {
        enable = true;
      };
    };
  };
}
