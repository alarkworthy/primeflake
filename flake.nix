{
  description = "Pluto";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-alark.url = "github:alarkworthy/nixpkgs/master";
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
    inputs @ {
      self,
      systems,
      nixpkgs-xr,
		  nixpkgs,
      nixpkgs-alark,
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
      };

      overlays = with inputs; [
  			(final: prev: {
    wivpkgs = nixpkgs-alark.legacyPackages."x86_64-linux";
  })

          #Put this in an overlay file, when done with snow melt ugh
          (final: prev:
            {
              wpa_supplicant = prev.wpa_supplicant.overrideAttrs (finalAttrs: previousAttrs: {
                patches = (previousAttrs.patches or []) ++ [
                (prev.fetchpatch {
                    name = "stop-journal-ctl-log-spam.patch";
                    url = "https://w1.fi/cgit/hostap/patch/?id=c330b5820eefa8e703dbce7278c2a62d9c69166a";
                    hash = "sha256-5ti5OzgnZUFznjU8YH8Cfktrj4YBzsbbrEbNvec+ppQ=";
                  })
                ];
              });
            })
				# (final: prev:{
				# 	xrizer1 = prev.xrizer.overrideAttrs (prevAttrs: rec {
				# 			version = "2a54e25bfac72afe4b695c7045dfb349efad76ed";
				# 			src = prev.fetchFromGitHub {
				# 				owner = "SpookySkeletons";
				# 				repo = "xrizer";
				# 				rev = version;
				# 				hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
				# 			};
				# 			cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
				# 		});
				# 	})
        nixpkgs-xr.overlays.default
        (final: prev:
          {
            wlx-overlay-s = prev.wlx-overlay-s.overrideAttrs (prevAttrs: {
              postPatch = nixpkgs.legacyPackages."x86_64-linux".wlx-overlay-s.postPatch;
              });
            xrizer = nixpkgs.legacyPackages."x86_64-linux".xrizer.overrideAttrs (prevAttrs: {
              src = prev.fetchFromGitHub {
                  owner = "RinLovesYou";
                  repo = "xrizer";
                  rev = "f491eddd0d9839d85dbb773f61bd1096d5b004ef";
                  hash = "sha256-12M7rkTMbIwNY56Jc36nC08owVSPOr1eBu0xpJxikdw=";
                };
              doCheck = false;
              });
          }
        )
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
      systems.modules.nixos = with inputs; [
        nixpkgs-xr.nixosModules.nixpkgs-xr
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        chaotic.nixosModules.default
        nix-gaming.nixosModules.pipewireLowLatency
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
