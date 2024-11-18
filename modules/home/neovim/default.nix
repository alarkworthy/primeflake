{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.programs.neovim;
in
{
  options.pluto.programs.neovim.enable = mkEnableOption "Enable Neovim" // {
    default = true;
  };
  config = mkIf cfg.enable {
    programs.neovim.defaultEditor = true;
    home.packages = [
      pkgs.nvim
    ];
  };
}
