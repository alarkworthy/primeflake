{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.theming.stylix;
in
{
  options.pluto.theming.stylix.enable = mkEnableOption "Enable Stylix NixModule" // {
    default = true;
  };
  options.pluto.system = mkOption {
    type = lib.types.str;
    default = "Desktop";
    example = "Laptop";
    description = "System type";
  };
  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image =
        if config.pluto.system == "Desktop" then
          "${./bgs/space/purplesky.jpg}"
        else if config.pluto.system == "Laptop" then
          "${./bgs/space/gcenter_radio.png}"
        else
          "${./bgs/space/purplesky.jpg}";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/spaceduck.yaml";

      #image = "${./bgs/nature/snowMountains1.jpg}";
      #Cool orange spiral galaxy close up
      #image = "${./bgs/nasa/spiral1.png}";
      #imageScalingMode = "fill";
      #polarity = "dark";
    };
  };
}
