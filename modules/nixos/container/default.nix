{config, pkgs, lib, ...}:
{
	networking.nat = {
		internalInterfaces = ["ve-+"];
		externalInterface = "enp113s0";
		enable = true;
	};
	containers = {
		webmail = {
			privateNetwork = true;
			localAddress = "10.231.136.2";
			hostAddress = "10.231.136.1";

			config = {config, pkgs,lib,... }:
			{
				imports = [
					(builtins.fetchTarball {
						url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/master/nixos-mailserver-master.tar.gz";
						sha256 = "0r8c0mkj7cn2cz0r6m45h51w5qwf2cyiiv956bz75p3fcps4qj1n";
					})
				];
					networking.firewall.enable = false;
					services.resolved.enable = true;
					networking.useHostResolvConf = lib.mkForce false;
					networking.wg-quick.interfaces = {
						email = {
							configFile = "/root/email.conf";
						};
					};
				system.stateVersion = "25.05";
			};
		};
	};
}
