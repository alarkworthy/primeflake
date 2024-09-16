{lib,config,pkgs,...}:
with lib;
let cfg = config.pluto.texLive;
in 
{
  options.pluto.texLive.enable = mkEnableOption "TexLive User wide" // {default = false;};
  
  config = mkIf cfg.enable {
    programs = {
        texlive = {
          enable = true;
          extraPackages = tpkgs: { inherit (tpkgs) collection-basic standalone pdfcrop collection-xetex collection-latex collection-mathscience collection-fontsrecommended collection-latexextra; };
        };
      };

  };
}
