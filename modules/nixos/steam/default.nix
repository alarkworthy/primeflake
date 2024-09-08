{lib, pkgs, config, ...}:
with lib;
let cfg = config.pluto.gaming.steam;
in {
  options.pluto.gaming.steam.enable = mkEnableOption "Enable Gaming NixOS Module" // {default = true;};
  config = mkIf cfg.enable {
#    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
#             "steam"
#             "steam-original"
#             "steam-run"
#             "xivlauncher"
#           ];
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      extest.enable = true;
      protontricks = {
        #package =
        enable = true;
      };

    };
  };


}
