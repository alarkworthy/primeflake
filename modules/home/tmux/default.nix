{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.terminal.tmux;

in
{
  options.pluto.terminal.tmux.enable = mkEnableOption "Terminal Multiplexer" // {
    default = true;
  };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      shortcut = "Space";
      aggressiveResize = true;
      baseIndex = 1;
      escapeTime = 0;
      newSession = false;
      clock24 = true;
      keyMode = "vi";
      terminal = "screen-256color";
      historyLimit = 5000;
      plugins = with pkgs.tmuxPlugins; [
        pain-control
				#{
				#  plugin = resurrect;
          #extraConfig = "set -g @ressurect-strategy-nvim 'session'";
				#}
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60'
          '';
        }

      ];
      extraConfig = ''
        bind-key C-Space send-prefix
      '';

    };
  };
}
