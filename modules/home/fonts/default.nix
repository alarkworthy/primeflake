{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.essentials.fonts;
in
{
  options.pluto.essentials.fonts.enable = mkEnableOption "Enable fonts" // {
    default = true;
  };
  config = mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;
    };
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      # noto-fonts-extra
      ipafont
      font-awesome # awesome 6
      fira-code
      fira-code-symbols
      corefonts
      vista-fonts
    ];
  };
}
