{config,lib,...}:
{
	options.pluto.desktop.qutebrowser.enable = lib.mkEnableOption "Enable Qutebrowser" // {
		default = true;
	};

	config = lib.mkIf config.pluto.desktop.qutebrowser.enable {
		programs.qutebrowser = {
			enable = true;
			searchEngines = {
		 		w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
				aw = "https://wiki.archlinux.org/?search={}";
        nw = "https://wiki.nixos.org/index.php?search={}";
        np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
        no = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
				ho = "https://home-manager-options.extranix.com/?query={}&release=master";
			};
		};
	};
}
