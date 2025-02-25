{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.tofi;
in
{
  options.pluto.desktop.tofi.enable = mkEnableOption "Enable Tofi" // {
    default = config.pluto.desktop.sway.enable;
  };
  config = mkIf cfg.enable {
    programs.tofi = {
      enable = true;

      settings = {
        #Stylix handles the following
        #font
        #font-size
        #background-color
        #outline-color
        #text-color
        #prompt-color
        #prompt-background
        #placeholder-color
        #input-background
        #default-result-background
        #selection-color
        #selection-background
        #border-width
        #outline-width
        corner-radius = 5;
        anchor = "center";
        scale = true;
        clip-to-padding = false;
        outline-width = 6;

        prompt-background-padding = 8;
        prompt-background-corner-radius = 5;

        selection-background-padding = 8;
        selection-background-corner-radius = 5;

        result-spacing = 3;

        input-background-padding = 8;
        input-background-corner-radius = 5;

        default-result-background-padding = 8;
        default-result-background-corner-radius = 5;
        padding-top = 20;
        padding-bottom = 10;
        padding-left = 15;
        padding-right = 10;

        terminal = "foot";
        width = "50%";
        height = "30%";
        prompt-text = "Give me a";
        prompt-padding = 20;
        font-size = lib.mkForce 24;
        #rice later dork
      };

    };

  };

}
