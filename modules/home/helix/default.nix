{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    home.packages = [
      pkgs.nixfmt-rfc-style
      pkgs.nil
      pkgs.nixd
    ];
    programs.helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";
        };
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
