{pkgs, lib, config, ...}:
with lib;
let cfg = config.pluto.communication;
in {
  options.pluto.communication.enable = mkEnableOption "Enable Communication" // {default = true;};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #discord#evil uwu
      #discord
      vesktop#For screenshare with audio
      #nheko #matrix client
      mpg123
      gp-saml-gui
      openconnect
    ];
    #services.easyeffects.enable = true; #need that background filter baby, later learn to autospawn in a workspace with discord
    services.arrpc.enable = true; 
  };
}
