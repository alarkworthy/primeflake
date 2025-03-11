{ lib, config,pkgs, ... }:
with lib;
let
  cfg = config.pluto.texLive;
	tex = (pkgs.texlive.combine {
		inherit (pkgs.texlive) scheme-medium;
	});
in
{
  options.pluto.texLive.enable = mkEnableOption "TexLive User wide" // {
    default = false;
  };

  config = mkIf cfg.enable {
		home.packages = with pkgs; [
			tex
		];
  };
}
