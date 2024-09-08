{lib , config, pkgs, ...}:
with lib;
let cfg = config.pluto.styling.stylix;
in
{
  options.pluto.styling.stylix.enable = mkEnableOption "Enable Stylix HomeManager" // {default = true;};
  config = mkIf cfg.enable {
	  programs.btop = {
	    enable = true;
	  };
	  stylix = {
	    enable = true;
	    #autoEnable = false;
	    targets = {
	      neovim.enable = false;
	      waybar.enable = true;
	      #Waybar back colors
	      waybar.enableLeftBackColors = false;
	      waybar.enableCenterBackColors = false;
	      waybar.enableRightBackColors = true;

	      kitty.variant256Colors = true;

	      firefox.profileNames = [ "default" ];
	    };
	    opacity = {
	      terminal = .7;
	      popups = .8;
	      desktop = .8;
	      applications = .7;
	    };

	    fonts = {
	      #emoji leave default who cares
	      monospace.name = "JetBrainsMono Nerd Font";
              monospace.package = (pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; });
	      sansSerif.name = "CommitMono Nerd Font";
#	      sansSerif.name = "DejaVuSansM Nerd Font";
	      sansSerif.package = with pkgs; (nerdfonts.override { fonts = ["CommitMono"]; });
#	      sansSerif.package = with pkgs; (nerdfonts.override { fonts = ["DejaVuSansMono"]; });
	      serif.name = "IosevkaTermSlab Nerd Font";
	      serif.package = with pkgs; (nerdfonts.override { fonts = ["IosevkaTermSlab"]; });

	     };
	  };
	};
}
