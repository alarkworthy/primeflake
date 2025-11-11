{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.i3status;

in
{
  options.pluto.desktop.i3status.enable = mkEnableOption "Enable i3status" // {
    default = config.pluto.desktop.sway.enable; # config.pluto.desktop.sway.enable;
  };
  config = mkIf cfg.enable {
    programs.i3status-rust = {
      enable = true;
      bars = {
        top = {
          blocks = [
            {
              block = "sound";
            }
            {
              block = "amd_gpu";
              format_alt = " $icon $vram_used / $vram_total ";
            }
            {
              block = "time";
            }
            {
              block = "cpu";
              interval = 10;
              format = " $icon $frequency $utilization ";
              format_alt = " $icon $frequency{ $boost|} ";
              info_cpu = 20;
              warning_cpu = 50;
              critical_cpu = 90;
            }
            {
              block = "battery";
              missing_format = "";
              #click = [{
              #		button = "left";
              #}];
            }
          ];
          #theme = "plain";
          settings = {
            theme = {
              theme = "plain";
              overrides = { } // config.lib.stylix.i3status-rust.bar;
            };
          };
          icons = "awesome6";
        };
      };
    };
  };
}
