{ lib, pkgs, ... }:

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
      hplip
      splix
      epson-escpr2
    ];
    browsing = true;
  };
  environment.systemPackages = [
    pkgs.acpi
    pkgs.eagle
    pkgs.powertop
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
      (pkgs.epsonscan2.override { withNonFreePlugins = true; })
    ];
    openFirewall = true;
  };
  #services.libinput = {
  #		enable = true;
  # };
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    #pkgs.linuxPackages_zen;
    initrd.kernelModules = [ "amdgpu" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
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
    enable = false;

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
  services.xserver.xkb = {
    layout = "us";
    variant = "3l";
  };
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
  networking.firewall = {
    allowedTCPPorts = [
      25565
    ];
    allowedUDPPorts = [
      25565
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
