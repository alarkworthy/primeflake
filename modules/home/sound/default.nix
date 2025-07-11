{config, lib, pkgs, ...}:
{
  options.pluto.sound.design.enable = lib.mkEnableOption "Sound Design apps" // {default = false;};
  config = lib.mkIf config.pluto.sound.design.enable {
    programs = {};
    services = {};
    home.packages = [
      # pkgs.lmms
      pkgs.ardour
      pkgs.zynaddsubfx
      pkgs.rosegarden
    ];
  };
}
