{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.styling.stylix;
in
{
  options.pluto.styling.stylix.enable = mkEnableOption "Enable Stylix HomeManager" // {
    default = true;
  };
  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      package = (pkgs.btop.override { rocmSupport = true; });
    };
    gtk = {
      enable = true;
      #			iconTheme = {
      #		name = "Fluent pink";
      #		package = (pkgs.fluent-icon-theme.override {colorVariants=["pink"];});
      #};
    };
    stylix = {
      enable = true;
      polarity = "dark";
      #autoEnab			sle = false;
      iconTheme = {
        enable = true;
        package = (pkgs.papirus-icon-theme.override { color = "blue"; });
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
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
        terminal = 0.7;
        popups = 0.8;
        desktop = 0.8;
        applications = 0.7;
      };
      #abc
      fonts = {
        #emoji leave default who cares
        monospace.name = "JetBrainsMono Nerd Font";
        monospace.package = pkgs.nerd-fonts.jetbrains-mono; # (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
        sansSerif.name = "CommitMono Nerd Font";
        #	      sansSerif.name = "DejaVuSansM Nerd Font";
        sansSerif.package = pkgs.nerd-fonts.commit-mono; # with pkgs; (nerdfonts.override { fonts = [ "CommitMono" ]; });
        #	      sansSerif.package = with pkgs; (nerdfonts.override { fonts = ["DejaVuSansMono"]; });
        serif.name = "IosevkaTermSlab Nerd Font";
        serif.package = pkgs.nerd-fonts.iosevka-term-slab; # with pkgs; (nerdfonts.override { fonts = [ "IosevkaTermSlab" ]; });
      };
    };
  };
}
