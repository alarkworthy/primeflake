{config, pkgs, lib, ...}:
with lib;
let cfg = config.pluto.gaming.xivlaunch;
in
{
  options.pluto.gaming.xivlaunch = mkEnableOption "Enable xivlauncher" // {default = true;};
}
