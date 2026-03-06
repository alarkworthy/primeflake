{
  description = "Pluto";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs-alark.url = "github:alarkworthy/nixpkgs/master";
    # musnix = {
    #   url = "github:musnix/musnix";
    # };

    container-config.url = ./modules/nixos/container;
    container-config.inputs.nixpkgs.follows = "nixpkgs";
    #hyprland = {
    #    url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #    inputs.nixpkgs.follows = "nixpkgs";
    #};
    #
    hytale = {
      url = "github:JPyke3/hytale-launcher-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # alarkpkgs = {
    #   url = "/home/alark/Documents/flakes/wivXnixpkgs/nixpkgs";
    # };
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
    clipboard-sync.url = "github:dnut/clipboard-sync";
    impermanence.url = "github:nix-community/impermanence";
    nixcord.url = "github:kaylorben/nixcord";
    #jovian = {
    #    url = "github:Jovian-Experiments/Jovian-NixOS";
    #    inputs.nixpkgs.follows = "nixpkgs";
    #};
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # neovim.url = "github:alarkworthy/neovim";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    aagl = {
      url = "github:ezKEA/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
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
      clipboard-sync,
      container-config,
      hytale,
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
          "qtwebengine-5.15.19"
          "mbedtls-2.28.10"
        ];
      };

      overlays = [
        # (final: prev: {
        #   wivpkgs = nixpkgs-alark.legacyPackages."x86_64-linux";
        # })
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
        (final: prev: {
          hytale-launcher = hytale.packages.x86_64-linux.default;
          sway-unwrapped = inputs.nixpkgs-wayland.packages.x86_64-linux.sway-unwrapped;
          xdg-desktop-portal-wlr = inputs.nixpkgs-wayland.packages.x86_64-linux.xdg-desktop-portal-wlr;
          # vrcx = inputs.alarkpkgs.legacyPackages."x86_64-linux".vrcx;
          # wlx-overlay-s = prev.wlx-overlay-s.overrideAttrs (prevAttrs: {
          #   postPatch = nixpkgs.legacyPackages."x86_64-linux".wlx-overlay-s.postPatch;
          # });
          #   wivrn = prev.wivrn.overrideAttrs (old: rec {
          #     # version = "9bed1c6c9df14b2c8c6f606ce3f27712ab4d499f";
          #     version = "6dfe6e88591af54a3e862ad7f3839457aab72bd1";
          #     src = final.fetchFromGitHub {
          #       owner = "ImSapphire";
          #       repo = "WiVRn";
          #       # owner = "notpeelz";
          #       # repo = "WiVRn";
          #       rev = version;
          #       hash = "sha256-EwnyGxil01IHHHQVNlDEx2N+loMNGW7hk9Bm/++7pPw=";
          #       # hash = "sha256-2s3j6vRtIRf6x+lQPobcuT1vzlCh1lMA54EUiCnxoFI=";
          #     };

          #     buildInputs = old.buildInputs ++ [
          #       final.librsvg
          #       final.libpng
          #       final.libarchive
          #       final.sdl2-compat
          #     ];
          #     monado = prev.applyPatches {
          #       src = prev.fetchFromGitLab {
          #         domain = "gitlab.freedesktop.org";
          #         owner = "monado";
          #         repo = "monado";
          #         rev = "20e0dacbdd2de863923790326beec76e848b056a";
          #         hash = "sha256-wiXdMgp3bKW17KqLnSn6HHhz7xbQtjp4c3aU7qp+2BE=";
          #         # rev = "06e62fc7d9c5cbcbc43405bb86dfde3bf01ce043";
          #         # hash = "sha256-0ALB9eLY4NAUqNOYZMwpvYnLxVpHsQDJc1er8Txdezs=";
          #       };

          #       postPatch = ''
          #         ${src}/patches/apply.sh ${src}/patches/monado/*
          #       '';
          #     };
          #     cmakeFlags = old.cmakeFlags ++ [
          #       (nixpkgs.lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)
          #     ];
          #   });
          #   xrizer = prev.xrizer.overrideAttrs (prevAttrs: rec {
          #     src = final.fetchFromGitHub {
          #       # owner = "Mr-Zero88-FBT";
          #       owner = "ImSapphire";
          #       repo = "xrizer";
          #       rev = "e6927b075f66ba7b12db94402cca35fa4979707c";
          #       hash = "sha256-h9DsVcwDDfj5P9uPp5fCR/BSWIQg3JntCcQwAWVu+Cw=";
          #       # rev = "d5aa044df545c6236b812431b0a620e6ce2195d2";
          #       # hash = "sha256-oMI+jjnDj3kFINA/KfbO6jOyxCivFB8BScA1mLJOw7o=";
          #     };
          #     doCheck = false;

          #     cargoDeps = final.rustPlatform.fetchCargoVendor {
          #       inherit src;
          #       hash = "sha256-tLPwiwKkEBdsRxXgdcTM9TLJeNRZV32W11qUbyCVdHw=";
          #     };
          #     # cargoDeps = prevAttrs.cargoDeps.overrideAttrs (prev.lib.const {
          #     #    inherit src;
          #     #    cargoHash = "";
          #     #    });
          #   });
          # })
          # neovim.overlays.default
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
        })
        nixpkgs-xr.overlays.default
        # inputs.nixpkgs-wayland.overlay
      ];
      systems = {
        container-config = container-config;
      };
      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        # chaotic.nixosModules.default
        nix-gaming.nixosModules.pipewireLowLatency
        # musnix.nixosModules.musnix
        aagl.nixosModules.default
        clipboard-sync.nixosModules.default
        #jovian.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        stylix.nixosModules.stylix
        nixpkgs-xr.nixosModules.nixpkgs-xr
        #hyprland.nixosModules.default
      ];
      homes.modules = with inputs; [
        #hyprland.homeManagerModules.default
        nixcord.homeModules.nixcord
        # chaotic.homeManagerModules.default
      ];

    }
    // {
      formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = forAllSystems (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

    };
}
