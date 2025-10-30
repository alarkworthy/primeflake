{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  pluto = {
    audio.enable = true;
    impermanence.enable = true;
    system = "Laptop";
    emulate.enable = false;
  };
  programs.light.enable = true;
  # services.thermald.enable = true;

  powerManagement = {
    powertop.enable = false;
    enable = true;
  };
  services.udisks2 = {
    enable = true;
  };

  programs.nix-ld.enable = true;
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
  services.upower.enable = true;
  programs.noisetorch.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;

  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  specialisation = {
    #   netPass.configuration = {
    #     networking.interfaces."eno1" = {
    #       useDHCP = false;
    #       address = "192.168.43.1";
    #       prefixLength = 24;
    #     };
    #     networking.firewall.extraCommands = ''
    #       iptables -t nat -A POSTROUTING -o wlp6s0
    # '';
    #     networking.nat = {
    #       enable = true;
    #       internalInterfaces = [
    #         "eno1"
    #       ];
    #       externalInterface = "wlp6s0";
    #     };
    #     boot.kernel = {
    #       sysctl = {
    #         "net.ipv4.ip_forward" = 1;
    #         "net.ipv4.conf.all.forwarding" = 1;
    #         "net.ipv6.conf.all.forwarding" = 1;
    #       };
    #     };
    #   };
    windowsDev.configuration = {
      environment.systemPackages = [
        pkgs.virt-viewer
        pkgs.distrobox
        pkgs.looking-glass-client
      ];
      system.nixos.tags = [ "gpu-pass" ];
      users.users.alark.extraGroups = [
        "libvirtd"
        "kvm"
      ];
      programs.virt-manager.enable = true;
      virtualisation = {
        # efi.OVMF =
        #   (pkgs.OVMF.override {
        #     secureBoot = true;
        #     tpmSupport = true;
        #   }).fd;
        libvirtd.enable = true;
        libvirtd.qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
        spiceUSBRedirection.enable = true;
      };
      boot.kernel.sysctl = {
        "vm.nr_hugepages" = 128;
      };
      boot.extraModulePackages = [
        config.boot.kernelPackages.kvmfr
      ];
      boot.kernelModules = [ "kvmfr" ];
      boot.extraModprobeConfig = ''
        options vfio-pci ids=1002:7480,1002:ab30
        softdep amdgpu pre: vfio-pci
        options kvmfr static_size_mb=32
      '';
      services.udev.extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="alark", GROUP="kvm", MODE="0660"
      '';
      virtualisation.libvirtd.qemu.verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm",
          "/dev/kvmfr0"
        ]
      '';
      boot.kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
        "vfio-pci.ids=1002:7480,1002:ab30"
        "video=efifb:off"
      ];
      boot.initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
    };
  };
  # i3c.configuration = {
  #   security.pam.services.i3lock.enable = true;
  #   services.xserver.windowManager.i3 = {
  #     extraPackages = [
  #       pkgs.dmenu
  #       pkgs.i3status-rust
  #     ];
  #     enable = true;
  #   };
  #   services.xserver = {
  #     enable = true;
  #     displayManager.startx.enable = true;
  #     xkb.layout = "us";
  #     desktopManager = {
  #       xterm.enable = false;
  #     };
  #   };
  #   services.displayManager.defaultSession = "none+i3";
  # };
  hardware.wooting.enable = true;
  hardware.enableAllFirmware = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "quiet";
      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 60;
      RUNTIME_PM_DRIVER_DENYLIST = "mei_me";
    };
  };

  systemd.sleep.extraConfig = ''
    		AllowSuspend=yes
    		AllowHibernation=yes
    		AllowHybridSleep=no
    		AllowSuspendThenHibernate=yes
    	'';

  security.pam.services.swaylock = { };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      # hplip
      splix
      # epson-escpr2
    ];
    browsing = true;
  };
  environment.systemPackages = [
    pkgs.acpi
    # pkgs.eagle
    pkgs.powertop
    pkgs.libgcc
  ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.hplipWithPlugin
      pkgs.sane-airscan
      # (pkgs.epsonscan2.override { withNonFreePlugins = true; })
    ];
    openFirewall = true;
  };
  #services.libinput = {
  #		enable = true;
  # };
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    #pkgs.linuxPackages_zen;
    # initrd.kernelModules = [ "amdgpu" ];
    loader.systemd-boot.enable = true;
    loader.systemd-boot.graceful = true;
    # loader.efi.canTouchEfiVariables = true;
    kernelParams = [
      "rcutree.enable_rcu_lazy=1"
      "resume_offset=53329980"
    ];
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
    enable = true;

    gpuOverclock.enable = false;
  };
  hardware.amdgpu = {
    initrd.enable = false;
    opencl.enable = false;
    #amdvlk = {
    #  enable = true;
    #  support32Bit.enable = true;
    #};
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };

  hardware.bluetooth = {
    enable = true;
  };

  networking = {
    networkmanager.enable = true;
    hostName = "lapdog";
  };

  time.timeZone = "US/Mountain";

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
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "3l";
  # };
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    #useXkbConfig = true;
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
      #"corectrl"
      "networkmanager"
      "video"
      "lp"
      "scanner"
      "audio"
      "input"
      "libvirtd"
      "netdev"
      "ubridge"
      "pipewire"
      "podman"
    ]; # Groups
    shell = pkgs.nushell;
    #TODO Set up secret management with sops-nix
  };
  # services.pixiecore = {
  #   dhcpNoBind = true;
  #   enable = true;
  #   openFirewall = true;
  #   mode = "quick";
  # };
  networking.firewall = {
    allowedTCPPorts = [
      25565
    ];
    allowedUDPPorts = [
      25565
      53
      67
    ];
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
