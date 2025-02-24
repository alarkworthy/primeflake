{
  config,
  lib,
  pkgs,
  ...
}:
with config.lib.stylix.colors;
let
  cfg = config.pluto.desktop.swaylock;
  inside = base01-hex;
  outside = base00-hex;
  ring = base05-hex;
  text = base05-hex;
  positive = base0B-hex;
  negative = base08-hex;
in
{
  options.pluto.desktop.swaylock.enable = lib.mkEnableOption "Enable Swaylock" // {
    default = false;
  };
  options.pluto.desktop.swaylock.idle.enable = lib.mkEnableOption "Enable Swayidle" // {
    default = false;
  };
  options.pluto.desktop.swaylock.idle.time.lock = lib.mkOption {
    type = lib.types.ints.unsigned;
    default = 900;
    example = 300;
    description = "Timeout until lockscreen is turned on";
  };
  options.pluto.desktop.swaylock.idle.time.suspend = lib.mkOption {
    type = lib.types.ints.unsigned;
    default = 1800;
    example = 420;
    description = "Timeout until system is suspended";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      stylix.targets.swaylock.enable = false;
      programs.swaylock = {
        enable = true;
        settings = {
          color = outside;
          scaling = "fill";
          inside-color = inside;
          inside-clear-color = inside;
          inside-caps-lock-color = inside;
          inside-ver-color = inside;
          inside-wrong-color = inside;
          key-hl-color = positive;
          layout-bg-color = inside;
          layout-border-color = ring;
          layout-text-color = text;
          line-uses-inside = true;
          ring-color = ring;
          ring-clear-color = negative;
          ring-caps-lock-color = ring;
          ring-ver-color = positive;
          ring-wrong-color = negative;
          separator-color = "00000000";
          text-color = text;
          text-clear-color = text;
          text-caps-lock-color = text;
          text-ver-color = text;
          text-wrong-color = text;
        };
      };
    })
    (lib.mkIf cfg.idle.enable {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = cfg.idle.time.lock;
            command = "${pkgs.swaylock}/bin/swaylock -fF";
          }
          {
            timeout = cfg.idle.time.suspend;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -fF";
          }
        ];
      };
    })
  ];

}
