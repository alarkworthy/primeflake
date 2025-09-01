{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.pluto.programs.helix.enable = lib.mkEnableOption "Enable Helix" // {
    default = true;
  };

  config = lib.mkIf config.pluto.programs.helix.enable {
    home.packages = [
      pkgs.nixfmt-rfc-style
      pkgs.nil
      pkgs.nixd
      pkgs.tinymist
      pkgs.typstyle
    ];

    stylix.targets.helix.transparent = lib.mkForce false;
    programs.helix = {
      enable = true;
      languages = {
        language-server = {
          nixd = {
            command = "nixd";
            args = [ "--semantic-tokens=true" ];
            config.nixd =
              let
                configPath = "/home/alark/Documents/flakes/primeflake/";
                configName = "deadmeat";
                primeFlake = "(builtins.getFlake (toString ${configPath}))";
                nixosOpts = "${primeFlake}.nixosConfigurations.${configName}.options";
              in
              {
                nixpkgs.expr = "import ${primeFlake}.inputs.nixpkgs { }";
                formatting.command = [ "nixfmt" ];
                options = {
                  nixos.expr = nixosOpts;
                  home-manager.expr = "${nixosOpts}.home-manager.users.type.getSubOptions []";
                };
              };
          };

          tinymist = {
            command = "tinymist";
            config = {
              preview.background.enabled = true;
              preview.background.args = [
                "--data-plane-host=127.0.0.1:23635"
                "--invert-colors=never"
                "--open"
              ];
            };
          };

        };

        language = [
          {
            name = "nix";
            auto-format = true;
          }
          {
            name = "typst";
            language-servers = [ "tinymist" ];
            formatter.command = "typstyle";
            auto-format = true;
          }
        ];
      };
      settings = {
        editor = {
          line-number = "relative";
        };
      };
    };
  };
}
