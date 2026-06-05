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
      pkgs.texlab
      pkgs.bibtex-tidy
      pkgs.basedpyright
      pkgs.codebook
      pkgs.typos-lsp
      pkgs.codebook
      pkgs.markdown-oxide
      pkgs.typstyle
      pkgs.superhtml
      # pkgs.forth-lsp
      pkgs.harper
      pkgs.vscode-css-languageserver
    ];

    stylix.targets.helix.transparent = lib.mkForce false;
    programs.helix = {
      enable = true;
      languages = {
        language-server = {
          harper-ls = {
            command = "harper-ls";
            args = [ "--stdio" ];
            config.harper-ls = {
              linters = {
                # SpellCheck = false;
              };

            };
          };
          codebook = {
            command = "codebook-lsp";
            args = [ "serve" ];
          };
          typos = {
            command = "typos-lsp";
            environment = {
              "Rust" = "error";
            };
            config.diagonosticSeverity = "Info";
          };
          nixd = {
            command = "nixd";
            args = [ "--semantic-tokens=true" ];
            config.nixd =
              let
                configPath = "/home/alark/config/primeflake/";
                configName = "lapdog";
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
            config =
              let
                argslist = [
                  # "--data-plane-host=127.0.0.1:23635"
                  "--invert-colors=never"
                  "--open"
                ];
              in
              {
                preview.browsing.args = argslist;
                preview.background.enabled = true;
                preview.background.args = argslist;
                formatterMode = "typstyle";
                formatterPrintWidth = 80;
                lint = {
                  enabled = true;
                };
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
            language-servers = [
              "tinymist"
              # "typos"
              "codebook"
              # "harper-ls"
            ];
          }
          {
            name = "python";
            language-servers = [ "basedpyright" ];
          }
        ];
      };
      settings = {
        editor = {
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "warning";
            other-lines = "error";
          };
          lsp = {
            display-inlay-hints = true;
          };
          line-number = "relative";
        };
      };
    };
  };
}
