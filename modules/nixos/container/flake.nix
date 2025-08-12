{

  description = "Flake-based container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
  };
  
  outputs = {self, nixpkgs, simple-nixos-mailserver }: {
    nixosModules.default = { config, pkgs, ...}: {
      imports = [ simple-nixos-mailserver.nixosModule ];

      mailserver = {
        enable = true;
      };

      system.stateVersion = "25.05";
    };
  };
}
