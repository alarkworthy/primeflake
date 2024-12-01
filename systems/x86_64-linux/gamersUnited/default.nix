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

  #NixOS modules
  pluto = {
    audio.enable = true;
  };

  services.printing.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    initrd.kernelModules = [ "amdgpu" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  #Hardware

  #Hardware Opengl
  hardware.graphics = {
    enable = true; # May not be needed, the system sway module auto enables this, but we are using homemanager to install sway
    extraPackages = with pkgs; [
      amdvlk # AMDVLK
      rocmPackages.clr.icd # OpenCL
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk # 32 Bit AMDVLK drivers
    ];

    #Force radv
    #enviroment.variables.AMD_VULKAN_ICD = "RADV";

    #VA-API
    #Might not need anything for this to work

  };

  #HIP workaround (used in blender)
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  #Razer

  hardware.openrazer = {
    enable = true;
    users = [ "alark" ];
    #batteryNotifier = false;
    #syncEffectsEnabled = false; #if sync flag true, assignment of effects will work across devices, defaults to true

  };
  #Note, there is openrgb support in NixOS options

  #Intel CPU
  hardware.cpu.intel = {
    updateMicrocode = true;
    #sgx.provision.enable = true #enables sgx, pls research more
  };

  #Bluetooth
  hardware.bluetooth = {
    enable = true;
    #powerOnBoot = false; default is true
    #Check Nix options for more
  };

  services.blueman.enable = true; # required for homemanager blueman-applet to work

  #Xbox stuff
  #hardware.xpadneo.enable = true; #For Xbox One wireless controllers

  #hardware.xone.enable = true; # For Xbox One and Xbox Series X|S accessories

  #Might look into hardware.fancontrol

  #End of Hardware

  #Network
  networking.hostName = "gamersUnited";
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #Time Zone
  time.timeZone = "US/Mountain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #Add User 'alark'
  #snowfallorg.users.alark = { };
  users.users.alark = {
    isNormalUser = true;
    description = "alark";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ]; # Groups
    shell = pkgs.nushell;
    #TODO Set up secret management with sops-nix
  };

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
