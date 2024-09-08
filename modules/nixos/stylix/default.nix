{config, lib, pkgs, ...}:
with lib;
let
  cfg = config.pluto.theming.stylix;
in {
  options.pluto.theming.stylix.enable = mkEnableOption "Enable Stylix NixModule" // {default = true;};
  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      
      image = "${./bgs/space/purplesky.jpg}";

      #image = "${./bgs/nature/snowMountains1.jpg}";
      #Cool orange spiral galaxy close up
      #image = "${./bgs/nasa/spiral1.png}";
      #imageScalingMode = "fill";
      polarity = "dark";
      targets = { 
        
      };
    };
  };
}
