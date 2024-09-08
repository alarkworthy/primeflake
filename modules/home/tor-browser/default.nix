{config,pkgs,lib,...}:
with lib;
let cfg = config.pluto.browser.tor;
in
{
  options.pluto.browser.tor.enable = mkEnableOption "Enable Tor Browser" // {default = true;};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tor-browser #for searching the interwebs
     # onionshare #for sharing files
    ];
  };
}
