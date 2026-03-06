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
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      ipafont
      monocraft
      miracode
      font-awesome # awesome 6
      pkgs.ttf_bitstream_vera
      pkgs.vista-fonts
      pkgs.corefonts
    ];
  };
}
