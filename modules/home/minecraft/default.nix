{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.pluto.gaming.minecraft;
in
{
  options.pluto.gaming.minecraft.enable = mkEnableOption "Enable Minecraft" // {
    default = true;
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zenity
      (prismlauncher.override {

        jdks = [

          # pkgs.javaPackages.compiler.temurin-bin.jdk-17
          # pkgs.javaPackages.compiler.temurin-bin.jdk-21
          pkgs.javaPackages.compiler.temurin-bin.jdk-25
          pkgs.javaPackages.compiler.temurin-bin.jdk-21

          pkgs.jdk21
          pkgs.jdk17
          pkgs.jdk8

        ];
      }

      )
      hytale-launcher
      # (mcpelauncher-ui-qt.overrideAttrs (prev: {
      #   runtimeDeps = [ pkgs.zenity ];
      # }))
    ];
  };
}
# hytale-launcher = hytale.packages.x86_64-linux.hytale-launcher;
