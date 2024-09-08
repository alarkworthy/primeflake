{config,pkgs,lib,...}:
with lib;
let cfg = config.pluto.essential.kitty;
in
{
  options.pluto.essential.kitty.enable = mkEnableOption "Enable Kitty" // {default = true;};
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      
      settings = {
        enable_audio_bell = false;
	update_check_interval = 0;
      };
    };
  };
}
