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
    # programs.noisetorch.enable = true;
    services.pipewire = {
      enable = true;
      #audio.enable = true #True if alsa | jack | pulse are enabled
      #wireplumber.enable = true; #Defaults to true, when pipewire.enable = true
      wireplumber.enable = true;
      # alsa.enable = true;
      # alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
      lowLatency = {
        enable = true;
        quantum = 800;
        rate = 48000;
      };

      configPackages = [
        # (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/99-deepfilternet.conf" ''
        #   context.modules = [
        #       { name = libpipewire-module-filter-chain
        #           args = {
        #               node.description = "DeepFilter Noise Canceling Sink"
        #               media.name       = "DeepFilter Noise Canceling Sink"
        #               filter.graph = {
        #                   nodes = [
        #                       {
        #                           type   = ladspa
        #                           name   = "DeepFilter Stereo"
        #                           plugin = ${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so
        #                           label  = deep_filter_stereo
        #                           control = {
        #                               "Attenuation Limit (dB)" 30
        #                           }
        #                       }
        #                   ]
        #               }
        #               audio.rate = 48000
        #               audio.channels = 2
        #               audio.position = [FL FR]
        #               capture.props = {
        #                   node.passive = true
        #               }
        #               playback.props = {
        #                   media.class = Audio/Source
        #               }
        #           }
        #       }
        #   ]            '')
      ];

      #jack.enable = true; #for JACK
      # extraConfig.pipewire."92-low-latency" = {
      # 	"context.properties" = {
      # 	"default.clock.rate" = 48000;
      # 	"default.clock.quantum" = 32;
      # 	"default.clock.min-quantum" = 32;
      # 	"default.clock.max-quantum" = 32;
      # 	};
      # };
      #    extraConfig.pipewire-pulse."92-low-latency" = {
      #      context.modules = [
      #        {
      #          name = "libpipewire-module-protocol-pulse";
      #          args = {
      #            pulse.min.req = "32/48000";
      #            pulse.default.req = "32/48000";
      #            pulse.max.req = "32/48000";
      #            pulse.min.quantum = "32/48000";
      #            pulse.max.quantum = "32/48000";
      #          };
      #        }
      #      ];
      #      stream.properties = {
      #        node.latency = "32/48000";
      #        resample.quality = 1;
      #      };
      #    };
    };
  };
}
