{
  config,
  lib,
  options,
  ...
}:
{
  options.pluto.home-manager.enable = lib.mkEnableOption "Enables Homemanager";
  config = lib.mkIf config.pluto.home-manager.enable {
    programs.home-manager.enable = true;
    home.stateVersion = lib.pluto.stateVersion.home;
  };
}
