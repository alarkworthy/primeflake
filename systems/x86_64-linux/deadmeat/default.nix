# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # specialisation.hdr.configuration = {
  # 	  pluto.desktop.plasma.enable = true;
  # 	};
  #NixOS modules
  pluto = {
    audio.enable = true;
    impermanence.enable = true;
    streaming.sunshine.enable = false;
    docker.enable = false;
    theming.stylix.enable = true;
		gaming.vrstuff.enable = false;
		gaming.wivr.enable = true;
  };

  environment.systemPackages = [
		#pkgs.quickemu
  ];


  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos; # 
		#	pkgs.linuxPackages_zen;
    #initrd.kernelModules = [ "amdgpu" ];
		#loader.systemd-boot.enable = true;
		#loader.efi.canTouchEfiVariables = true;

  };
	boot.loader = {
			efi.canTouchEfiVariables = true;
			grub = {
				enable = true;
				devices = [ "nodev" ];
				efiSupport = true;
				useOSProber = true;
			};
		};
  #Hardware

  #Hardware Opengl
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
    enable = true;
    gpuOverclock.enable = true;
  };
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    amdvlk = {
      enable = false;
      support32Bit.enable = false;
    };
  };

  hardware.cpu.amd.ryzen-smu.enable = true;
  #HIP workaround (used in blender)
  #systemd.tmpfiles.rules = [
  #"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  #];

  #Razer

  hardware.openrazer = {
    enable = true;
    users = [ "alark" ];
    #batteryNotifier = false;
    #syncEffectsEnabled = false; #if sync flag true, assignment of effects will work across devices, defaults to true

  };
  #Note, there is openrgb support in NixOS options

  #Bluetooth
  hardware.bluetooth = {
    enable = true;
    #powerOnBoot = false; default is true
    #Check Nix options for more
  };

  #Xbox stuff
  #hardware.xpadneo.enable = true; #For Xbox One wireless controllers

  #hardware.xone.enable = true; # For Xbox One and Xbox Series X|S accessories

  #Might look into hardware.fancontrol

  #End of Hardware
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;

    };

  };
  #Network
	services.avahi = {
  	enable = true;
  	nssmdns4 = true;
  	openFirewall = true;
	};
  networking = {
    hostName = "deadmeat";
    useDHCP = false;
    #interfaces."virbr0".virtualType = "tun";
    networkmanager = {
      enable = true;
      unmanaged = [
        #"esp113s0"
        "virbr0"
      ];
    };
    interfaces = {

    };
    #bridges."br0".interfaces = ["enp113s0"];
    #interfaces."br0" = {
    #  ipv4.addresses = [ {address="192.168.50.198"; prefixLength = 24;} ];
    #virtual = true;
    # };
    #defaultGateway = "192.168.50.1";
    # nameservers = ["10.100.0.1" "192.168.50.1"];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #Time Zone
  time.timeZone = "US/Mountain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
	services.printing = {
		enable = true;
		drivers = with pkgs; [
			gutenprint
			epsonscan2
			epson-escpr
			epson-escpr2
		];
	};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #Add User 'alark'
  #snowfallorg.users.alark = { };
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
      "pipewire"
    ]; # Groups
    shell = pkgs.nushell;
    #TODO Set up secret management with sops-nix
  };

  #users.users.root.initialPassword = "pass";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall = {
    allowedTCPPorts =
      [ 
      ];
    allowedUDPPorts = [
      
			53
      67
    ];
    trustedInterfaces = [
      "waydroid0"
    ];
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 49860 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 49860 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 49860 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 49860 -j RETURN || true
    '';
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = lib.pluto.stateVersion.nixos; # Did you read the comment?

}
