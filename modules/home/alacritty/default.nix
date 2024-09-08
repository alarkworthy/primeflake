{config, pkgs,lib, ...}:
with lib;
let cfg = config.pluto.essential.alacritty;
in
{
  options.pluto.essential.alacritty.enable = mkEnableOption "Enable Alacritty" // {default = false; };
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      #settings =
    };
  };
}
