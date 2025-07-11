{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        nixd
        nil
        nixpkgs-fmt
      ];
      settings = {
      };
      languages = {

        language = [
          {
            name = "nix";
            formatter = {
              command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            };
            auto-format = true;
          }
        ];
      };
    };
  };
}
