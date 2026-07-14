{ lib, ... }:

{
  stateVersion =
    let
      ver = "24.11";
    in
    {
      nixos = ver;
      home = ver;
    };

}
