{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.programs.starship;
in
#flavour = "mocha";
{
  options.pluto.programs.starship.enable = mkEnableOption "Terminal theming application" // {
    default = true;
  };
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = mkDefault false;
        battery = mkDefault {
          full_symbol = "🔋";
          charging_symbol = "⚡️";
          discharging_symbol = "💀";
          display = [
            {
              threshold = 10;
              style = "bold red";
            }
            {
              threshold = 30;
              style = "bold yellow";
            }
          ];
        };
        username = {
          show_always = mkDefault true;
          style_user = mkDefault "bold green";
          style_root = mkDefault "bold red";
        };
        directory = {
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        };
        format = "$all"; # Remove this line to disable the default prompt format
        #palette = "catppuccin_${flavour}";
      }; # // builtins.fromTOML (builtins.readFile
      #(pkgs.fetchFromGitHub
      #  {
      #    owner = "catppuccin";
      #    repo = "starship";
      #    rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f"; # Replace with the latest commit hash
      #    sha256 = "nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
      #  } + /palettes/${flavour}.toml))
      #  // ({character.vimcmd_symbol = "[❮](bold green)";});

      #remove all the catpuccin stuff, and make sure never to use vimcmd_symbol bc it breaks in nushell bruh

      enableNushellIntegration = true;
    };

    home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
  };
}
