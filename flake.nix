{
  description = "Pluto";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-alark.url = "github:alarkworthy/nixpkgs/master";
    musnix = {
      url = "github:musnix/musnix";
    };

    container-config.url = ./modules/nixos/container;
    container-config.inputs.nixpkgs.follows = "nixpkgs";
    #hyprland = {
    #    url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #    inputs.nixpkgs.follows = "nixpkgs";
    #};
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixcord.url = "github:kaylorben/nixcord";
    #jovian = {
    #    url = "github:Jovian-Experiments/Jovian-NixOS";
    #    inputs.nixpkgs.follows = "nixpkgs";
    #};
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    neovim.url = "github:alarkworthy/neovim";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  #   outputs = inputs:
  #       inputs.snowfall-lib.mkFlake {
  #           # You must provide our flake inputs to Snowfall Lib.
  #           inherit inputs;

  #           # The `src` must be the root of the flake. See configuration
  #           # in the next section for information on how you can move your
  #           # Nix files to a separate directory.
  #           src = ./.;

  #           snowfall = {
  #             namespace = "Pluto";
  #           };

  #           home.users."alark@gamersUnited".modules = with inputs; [
  #            snowfall-lib.homeModules.user
  #           ];

  #           systems.modules.nixos = with inputs; [
  #             home-manager.nixosModules.home-manager
  #           ];

  #       };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs-xr,
      nixpkgs,
      nixpkgs-alark,
      container-config,
      ...
    }:
    let
      forAllSystems =
        f: inputs.nixpkgs.lib.genAttrs (import systems) (system: f inputs.nixpkgs.legacyPackages.${system});
      treefmtEval = forAllSystems (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
      liba = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "pluto";
            title = "Pluto";
          };
          namespace = "pluto";
        };
      };
    in
    liba.mkFlake {
      channels-config = {
        allowUnfree = true; # Allow unfree packages
        permittedInsecurePackages = [
                "libxml2-2.13.8"
              ];
      };

      overlays = with inputs; [
        (final: prev: {
          wivpkgs = nixpkgs-alark.legacyPackages."x86_64-linux";
        })
        # (final: prev: {
        #   slimevr = prev.slimevr.overrideAttrs (prevAttrs: let
        #     inherit (prevAttrs) pname;
        #     version = "0.16.0-a";
        #     src = final.fetchFromGitHub {
        #         owner = "SlimeVR";
        #         repo = "SlimeVR-Server";
        #         rev = "3ec6a617637e4f3bc2ee2c9c290cb5740afd7808";
        #         hash = "sha256-ZYL+aBrADbzSXnhFzxNk8xRrY0WHmHCtVaC6VfXfLJw=";
        #         fetchSubmodules = true;
        #       };
        #     in {
        #     inherit version src;
        #     cargoHash = "sha256-BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        #
        #     pnpmDeps = prev.pnpm_9.fetchDeps {
        #         pname = "${pname}-pnpm-deps";
        #         inherit version src;
        #         hash = "sha256-lh5IKdBXuH9GZFUTrzaQFDWCEYj0UJhKwCdPmsiwfCs=";
        #       };
        #     });
        # })
        #Put this in an overlay file, when done with snow melt ugh
        # (final: prev: {
        #   wpa_supplicant = prev.wpa_supplicant.overrideAttrs (
        #     finalAttrs: previousAttrs: {
        #       patches = (previousAttrs.patches or [ ]) ++ [
        #         (prev.fetchpatch {
        #           name = "stop-journal-ctl-log-spam.patch";
        #           url = "https://w1.fi/cgit/hostap/patch/?id=c330b5820eefa8e703dbce7278c2a62d9c69166a";
        #           hash = "sha256-5ti5OzgnZUFznjU8YH8Cfktrj4YBzsbbrEbNvec+ppQ=";
        #         })
        #       ];
        #     }
        #   );
        # })
        nixpkgs-xr.overlays.default
        (final: prev: {
          wlx-overlay-s = prev.wlx-overlay-s.overrideAttrs (prevAttrs: {
            postPatch = nixpkgs.legacyPackages."x86_64-linux".wlx-overlay-s.postPatch;
          });

          wivrn = prev.wivrn.overrideAttrs(old: rec {
              version = "debdbac87184b598cc064fcff7f4759dd527a048";
              src = final.fetchFromGitHub {
                owner = "notpeelz";
                repo = "WiVRn";
                rev = version;
                hash = "sha256-IInUGSpAEX2SFTDMzXpjUp4Y6swiHXaLd9m5aRCNtp4=";
              };
              
              buildInputs = old.buildInputs ++ [
                final.librsvg
                final.libpng
                final.libarchive
              ];
              monado = prev.applyPatches {
                src = prev.fetchFromGitLab {
                  domain = "gitlab.freedesktop.org";
                  owner = "monado";
                  repo = "monado";
                  rev = "5c137fe28b232fe460f9b03defa7749adc32ee48";
                  hash = "sha256-4P/ejRAitrYn8hXZPaDOcx27utfm+aVLjtqL6JxZYAg=";
                };

                postPatch = ''
                  ${src}/patches/apply.sh ${src}/patches/monado/*
                '';
              };
              cmakeFlags = old.cmakeFlags ++ [
                (nixpkgs.lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)
              ];
            });
          xrizer = prev.xrizer.overrideAttrs (prevAttrs: rec {
            src = final.fetchFromGitHub {
              owner = "Mr-Zero88-FBT";
              repo = "xrizer";
              rev = "d5aa044df545c6236b812431b0a620e6ce2195d2";
              hash = "sha256-oMI+jjnDj3kFINA/KfbO6jOyxCivFB8BScA1mLJOw7o=";
            };
            doCheck = false;

            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit src;
              hash = "sha256-87JcULH1tAA487VwKVBmXhYTXCdMoYM3gOQTkM53ehE=";
            };
            # cargoDeps = prevAttrs.cargoDeps.overrideAttrs (prev.lib.const {
            #    inherit src;
            #    cargoHash = "";
            #    });
          });
        })
        neovim.overlays.default
        # (final: prev:
        #   {
        #     wivrn = prev.wivrn.overrideAttrs(finalAttrs: prevAttrs: {
        #       version = "git-solarxr";
        #       src = prev.fetchFromGitHub {
        #         owner = "notpeelz";
        #         repo = "wivrn";
        #         rev = "415bb70fd881e60a6bcaf95aaebc04eff0901e44";
        #         hash = "sha256-v38v3cyix5A7HM88ryJmvDOo0ycZqqBZwO+hqgxoSIA=";
        #       };
        #       monado = final.applyPatches {
        #         src = final.fetchgit {
        #             url = "https://gitlab.freedesktop.org/monado/monado.git";
        #             rev = "2a6932d46dad9aa957205e8a47ec2baa33041076";
        #             fetchSubmodules = false;
        #             deepClone = false;
        #             leaveDotGit = false;
        #             sparseCheckout = [];
        #             sha256 = "sha256-Bus9GTNC4+nOSwN8pUsMaFsiXjlpHYioQfBLxbQEF+0=";
        #           };
        #         };
        #       postUnpack = '' '';
        #     });
        #   })
      ];
      systems = { container-config = container-config; };
      systems.modules.nixos = with inputs; [
        nixpkgs-xr.nixosModules.nixpkgs-xr
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        chaotic.nixosModules.default
        nix-gaming.nixosModules.pipewireLowLatency
        musnix.nixosModules.musnix
        #jovian.nixosModules.default
        #{
        #  home-manager.useGlobalPkgs = true;
        #  home-manager.useUserPackages = true;
        #}
        stylix.nixosModules.stylix
        #hyprland.nixosModules.default
      ];
      homes.modules = with inputs; [
        #hyprland.homeManagerModules.default
        nixcord.homeModules.nixcord
        chaotic.homeManagerModules.default
      ];

    }
    // {
      formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = forAllSystems (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

    };
}
