{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.languages;
in
{
  options.pluto.languages.enable = mkEnableOption "Enable Languages" // {
    default = false;
  };
  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
				fcitx5-chinese-addons
				fcitx5-configtool
				fcitx5-gtk
				fcitx5-pinyin-zhwiki
				fcitx5-pinyin-minecraft
			];
    };

  };
}
