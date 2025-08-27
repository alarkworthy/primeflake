{ lib, ... }:
let
  version = "24.11";
in
{
  stateVersion = {
    nixos = version;
    home = version;
  };

}
