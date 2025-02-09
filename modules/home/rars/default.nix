{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.pluto.emulation.rars.enable = lib.mkEnableOption "Enable RARS" // {
    default = false;
  };
  config = lib.mkIf config.pluto.emulation.rars.enable {
    home.packages = [
      pkgs.rars
    ];
  };

}
