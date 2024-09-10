{ config, lib, pkgs, ...}:

with lib;
let
  cfg = config.pluto.emulate;
in {
  options.pluto.emulate.enable = mkEnableOption "Emulator Options" // {
    default = true;
  };
  config = mkIf cfg.enable {
    virtualisation = {
      waydroid.enable = true;

    };

  };
}
