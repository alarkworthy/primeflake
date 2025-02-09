{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.essentials;
in
{
  options.pluto.audio.enable = mkEnableOption "Enable Audio";
  #Sound
  config = mkIf cfg.enable {
    security.rtkit.enable = true; # hands out raltime scheduling priority to user proccesses on demand.
    #programs.noisetorch.enable = true;
    services.pipewire = {
      enable = true;
      #audio.enable = true #True if alsa | jack | pulse are enabled
      #wireplumber.enable = true; #Defaults to true, when pipewire.enable = true
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true; #for JACK
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
    };
  };
}
