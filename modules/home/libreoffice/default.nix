{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.libre;
in
{
  options.pluto.desktop.libre.enable = mkEnableOption "Enable LibreOffice" // {
    default = true;
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-fresh
      hunspell
      hunspellDicts.en_US
    ];
  };
}
