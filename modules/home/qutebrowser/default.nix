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
        nw = "https://wiki.nixos.org/w/index.php?search={}";
        np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
        no = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
				ho = "https://home-manager-options.extranix.com/?query={}&release=master";
				g = "https://www.google.com/search?hl=en&q={}";
			};
			settings = {
				tabs = {
					position = "right";
					width = "10%";
				};
				editor = {
					command = ["foot"
						"-T"
						"auxiliary text edit"
						"nvim"
						"{file}"
						#"+startinsert"
						"+call cursor({line}, {column})"
					];
				};
				fileselect = {
					folder.command = ["foot" "ranger" "--choosedir={}"];
					multiple_files.command = ["foot" "ranger" "--choosefiles={}"];
					single_file.command = ["foot" "ranger" "--choosefile={}"];
					handler = "external";
				};
			};
			keyBindings = {
				normal = {
					",d" = "config-cycle colors.webpage.darkmode.enabled true false";
				};
			};
		};
		#Used for file selection
		programs.ranger = {
			enable = true;
			plugins = [
				{
    			name = "zoxide";
					src = builtins.fetchGit {
						url = "https://github.com/jchook/ranger-zoxide.git";
						rev = "363df97af34c96ea873c5b13b035413f56b12ead";
					};
  			}
			];
			mappings = {
				cz = "zi";
			};
		};
	};
}
