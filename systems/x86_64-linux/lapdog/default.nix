{lib, pkgs, ...}:

{
	imports = [
		./hardware-configuration.nix
	];

	pluto = {
		audio.enable = true;
		impermanence.enable = true;
	};

	services.thermald.enable = true;
		services.tlp.settings = {
			CPU_BOOST_ON_AC = 1;
			CPU_BOOST_ON_BAT = 0;
			CPU_HWP_DYN_BOOST_ON_AC = 1;
			CPU_HWP_DYN_BOOST_ON_BAT = 0;
			CPU_SCALING_GOVERNOR_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
			CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
		};
	services.printing.enable = true;

  boot = {
    #kernelPackages = pkgs.linuxPackages_cachyos; # pkgs.linuxPackages_zen;
    #initrd.kernelModules = [ "amdgpu" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  hardware.graphics = {
    enable = true; # May not be needed, the system sway module auto enables this, but we are using homemanager to install sway
    enable32Bit = true;
    #extraPackages = with pkgs; [
    #  amdvlk #AMDVLK
    #  rocmPackages.clr.icd #OpenCL
    #];   
    #extraPackages32 = with pkgs; [
    #  driversi686Linux.amdvlk #32 Bit AMDVLK drivers
    #  ];

    #Force radv
    #enviroment.variables.AMD_VULKAN_ICD = "RADV";

    #VA-API
    #Might not need anything for this to work

  };
  programs.dconf.enable = true;
  programs.corectrl = {
    enable = false;
    gpuOverclock.enable = true;
  };
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

	hardware.bluetooth = {
		enable = true;
	};

	networking = {
		networkmanager.enable = true;
		hostName = "lapdog";
	};
	
	time.timeZone = "US/Mountain";

  i18n={
		defaultLocale = "en_US.UTF-8"; 
		inputMethod= {
			type = "fcitx5";
			enable = true;
			fcitx5.addons = with pkgs; [ fcitx5-gtk
				fcitx5-chinese-addons
				fcitx5-configtool
			];
		};
	};
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #packages = [ 
    #  ]; #Put fonts and stuff here for console to use
    #useXkbConfig = true; # use xkb.options in tty. Uses Xserver font/keyboard config
	};
	
  users.users.alark = {
    #initialPassword = "abc";
    isNormalUser = true;
    description = "alark";
    extraGroups = [
      "wheel"
      "kvm"
      "corectrl"
      "networkmanager"
      "video"
      "audio"
      "input"
      "libvirtd"
      "netdev"
      "ubridge"
    ]; # Groups
    shell = pkgs.nushell;
    #TODO Set up secret management with sops-nix
	};

	networking.firewall = {
		 extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 49860 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 49860 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 49860 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 49860 -j RETURN || true
    '';
	};

	system.stateVersion = lib.pluto.stateVersion.nixos;
}
