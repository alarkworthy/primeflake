{lib, config, pkgs, ...}:
with lib;
let cfg = config.pluto.programs.neovim;
in
{
  options.pluto.programs.neovim.enable = mkEnableOption "Enable Neovim" // {default = true;};
  config = mkIf cfg.enable {
    programs.neovim = {
	  enable = true;
	  defaultEditor = true;
	  extraPackages = with pkgs; [
	    gcc
	    #nodejs_21
	    lua-language-server
	    nil
	    #texliveFull
	    ];
    };
	  home.file.".config/nvim/init.lua".source = ./init.lua;
	  home.file = {
	    ".config/nvim/lua" = {
	    source = ./lua;
	    recursive = true;
	    };
	
	  };

  };
}
