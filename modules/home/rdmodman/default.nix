{config, pkgs, lib, ...}:
with lib;
let cfg = config.pluto.mods.lethalmod;
in
{
  options.pluto.mods.lethalmod.enable = mkEnableOption "Enable R2ModMan" // {default = false;};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ r2modman ];
  };
}
