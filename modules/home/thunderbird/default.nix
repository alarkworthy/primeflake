{
config,
pkgs,
lib, 
...
}:
{
	options.pluto.desktop.thunderbird.enable = lib.mkEnableOption "Enable Thunderbird" // {
		default = false;
	};

	config = lib.mkIf config.pluto.desktop.thunderbird.enable {
		programs.thunderbird = {
			enable = true;
			profiles = {
				alarkSchool = {
					isDefault = true;
					withExternalGnupg = true;
				};
			};

		};
		accounts.email.accounts = {
			alarkSchool = {
				primary = true;
				realName = "Andrew Larkworthy";
				address = "alarkworthy@mines.edu";
				thunderbird = {
					enable = true;
				};

			};
			alarkPersonal = {
				address = "andrew@larkworthy.org";
				realName = "Andrew Larkworthy";
			};
		};
	};
}
