# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  environment.variables = {
    DXVK_HUD = 0;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.joycond.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # List by default
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2_13
      acl
      libsodium
      util-linux
      xz
      systemd
      gtk3
      libx11
      libxml2

      libgcc
      gdk-pixbuf

      webkitgtk_4_1
      # My own additions
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL
      libva
      pipewire
      xorg.libxcb
      xorg.libXdamage
      xorg.libxshmfence
      xorg.libXxf86vm
      libelf

      # Required
      glib
      gtk2

      # Inspired by steam
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/st/steam/package.nix#L36-L85
      networkmanager
      vulkan-loader
      libgbm
      libdrm
      libxcrypt
      coreutils
      pciutils
      zenity
      # glibc_multi.bin # Seems to cause issue in ARM

      # # Without these it silently fails
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXi
      xorg.libSM
      xorg.libICE
      gnome2.GConf
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      ffmpeg
      # Only libraries are needed from those two
      libudev0-shim

      # needed to run unity
      gtk3
      icu
      libnotify
      gsettings-desktop-schemas
      # https://github.com/NixOS/nixpkgs/issues/72282
      # https://github.com/NixOS/nixpkgs/blob/2e87260fafdd3d18aa1719246fd704b35e55b0f2/pkgs/applications/misc/joplin-desktop/default.nix#L16
      # log in /home/leo/.config/unity3d/Editor.log
      # it will segfault when opening files if you don’t do:
      # export XDG_DATA_DIRS=/nix/store/0nfsywbk0qml4faa7sk3sdfmbd85b7ra-gsettings-desktop-schemas-43.0/share/gsettings-schemas/gsettings-desktop-schemas-43.0:/nix/store/rkscn1raa3x850zq7jp9q3j5ghcf6zi2-gtk+3-3.24.35/share/gsettings-schemas/gtk+3-3.24.35/:$XDG_DATA_DIRS
      # other issue: (Unity:377230): GLib-GIO-CRITICAL **: 21:09:04.706: g_dbus_proxy_call_sync_internal: assertion 'G_IS_DBUS_PROXY (proxy)' failed

      # Verified games requirements
      xorg.libXt
      xorg.libXmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      libidn
      tbb

      # Other things from runtime
      flac
      freeglut
      libjpeg
      libpng
      libpng12
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libappindicator-gtk2
      libdbusmenu-gtk2
      libindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      xorg.libXft
      libvdpau
      # ...
      # Some more libraries that I needed to run programs
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      dbus
      alsa-lib
      expat
      # for blender
      libxkbcommon

      libxcrypt-legacy # For natron
      libGLU # For natron

      # Appimages need fuse, e.g. https://musescore.org/fr/download/musescore-x86_64.AppImage
      fuse
      e2fsprogs
    ];
  };

  # specialisation.hdr.configuration = {
  # 	  pluto.desktop.plasma.enable = true;
  # 	};
  #NixOS modules
  pluto = {
    audio.enable = true;
    impermanence.enable = false;
    streaming.sunshine.enable = false;
    docker.enable = false;
    theming.stylix.enable = true;
    gaming.vrstuff.enable = true;
    essential.gnomekeyring.enable = true;
    gaming.wivr.enable = true;
  };
  services.hardware.openrgb = {
    enable = true;
  };

  # services.clipboard-sync.enable = true;
  # boot.nixStoreMountOpts = [
  #   "nodev"
  #   "nosuid"
  #   "recovery"
  #   "skip_bad_blocks"
  # ];
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  security.soteria.enable = true;
  nix.settings = inputs.aagl.nixConfig // {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
  };
  programs = {
    anime-game-launcher.enable = false;
    anime-games-launcher.enable = false;
    honkers-railway-launcher.enable = false;
    honkers-launcher.enable = false;
    wavey-launcher.enable = false;
    sleepy-launcher.enable = false;
  };

  xdg.portal = {
    wlr = {
      enable = true;

      settings.screencast = {
        chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel -d";
        chooser_type = "dmenu";
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    enable = true;
    config = {
      sway = {
        default = [ "gtk" ];

        "org.freedesktop.impl.portal.Screencast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  services.flatpak.enable = true;
  # musnix.enable = false;
  hardware.wooting.enable = true;
  # environment.pathsToLink = [
  #   "/share/xdg-desktop-portal"
  #   "/share/applications"
  virtualisation.containers.enable = true;
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
  # ];
  environment.systemPackages = [
    pkgs.vintagestoryPackages.latest
    pkgs.corefonts
    pkgs.gdbHostCpuOnly
    pkgs.android-tools
    pkgs.ryubing
    pkgs.ryujinxV
    pkgs.vkbasalt
    pkgs.goverlay
    pkgs.mangohud
    # pkgs.javaPackages.compiler.temurin-bin.jdk-25
    pkgs.crosspipe
    # pkgs.distrobox
    pkgs.jdk17
    pkgs.limo
    pkgs.qbittorrent
    pkgs.wootility
    pkgs.wayvr
    pkgs.wineWow64Packages.full
    pkgs.fuzzel
    pkgs.fastfetch
    pkgs.hyfetch
    pkgs.cameractrls-gtk4
    # pkgs.spice
    # pkgs.win-virtio
    # pkgs.win-spice
    # pkgs.spice-protocol
    # pkgs.spice-gtk
    pkgs.alcom
    pkgs.retroarch-full
    pkgs.melonds
    # pkgs.bsnes-hd
    pkgs.dolphin-emu
    pkgs.rpcs3
    pkgs.pcsx2
    pkgs.eden
    pkgs.p7zip
    pkgs.anki
    pkgs.xenia-canary
    pkgs.dusklight
    pkgs.ani-cli
    # pkgs.shipwright
    # pkgs.zelda64recomp
    (pkgs.mpv.override {
      scripts = [
        pkgs.mpvScripts.mpris
        pkgs.mpvScripts.quality-menu
      ];
    })
    pkgs.music-discord-rpc
    pkgs.vlc
    pkgs.libnotify
  ];

  services.udev.packages = [
    pkgs.dolphin-emu
  ];
  programs.envision = {
    enable = false;
    openFirewall = false;
  };
  #environment.systemPackages = [
  #pkgs.quickemu
  #pkgs.envision-unwrapped
  #];

  # Use the systemd-boot EFI boot loader.
  boot = {
    # kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride { mArch = "ZEN4"; };
    # kernelPackages = pkgs.linuxPackagesFor (
    #   pkgs.linux_zen.override {
    #     extraConfig = ''
    #       SDCARDFS m
    #     '';
    #   }
    # );
    kernelPackages = pkgs.linuxPackages_zen;
    #initrd.kernelModules = [ "amdgpu" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernel = {
      sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };
    };

  };
  #boot.loader = {
  #  efi.canTouchEfiVariables = true;
  #  grub = {
  #    enable = true;
  #    devices = [ "nodev" ];
  #    efiSupport = true;
  #    useOSProber = true;
  #  };
  #};
  #Hardware
  zramSwap = {
    enable = false;
    memoryPercent = 100;
  };

  #Should not be here but troubleshooting
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

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
  # programs.corectrl = {
  #   enable = true;
  # };

  services.lact = {
    enable = true;
  };

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    overdrive.enable = true;
    overdrive.ppfeaturemask = "0xffffffff";
  };

  #hardware.cpu.amd.ryzen-smu.enable = true;
  #HIP workaround (used in blender)
  #systemd.tmpfiles.rules = [
  #"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  #];

  # hardware.uni-sync = {
  #   enable = true;
  # };
  #Razer

  hardware.openrazer = {
    enable = false;
    users = [ "alark" ];
    #batteryNotifier = false;
    #syncEffectsEnabled = false; #if sync flag true, assignment of effects will work across devices, defaults to true

  };
  #Note, there is openrgb support in NixOS options

  services.pipewire.wireplumber.extraConfig."99-disable-suspend" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_output.pci-0000_7e_00.6.iec958-stereo";
          }
          {
            "node.name" =
              "alsa_input.usb-Blue_Microphones_Yeti_X_2049SG00LBZ8_888-000313110306-00.analog-stereo";
          }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }
    ];
  };
  #Bluetooth
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
    options btusb enable_autosuspend=0
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Name = "Nintendo";
        FastConnectable = true;
        Experimental = true;
      };
    };
    input = {
      General = {
        ClassicBondedOnly = false;
        UserspaceHID = false;
      };
    };
    #powerOnBoot = false; default is true
    #Check Nix options for more
  };

  #Xbox stuff
  #hardware.xpadneo.enable = true; #For Xbox One wireless controllers

  # hardware.xpad-noone.enable = true;
  hardware.xone.enable = true; # For Xbox One and Xbox Series X|S accessories

  #Might look into hardware.fancontrol

  #End of Hardware
  boot.binfmt = {
    emulatedSystems = [ "riscv64-linux" ];
    preferStaticEmulators = true;
  };
  programs.virt-manager.enable = false;
  virtualisation = {
    libvirtd = {
      enable = false;
      qemu = {
        package = pkgs.qemu_kvm.override {
          gtkSupport = true;
          sdlSupport = true;
          openGLSupport = true;
        };
        swtpm.enable = true;
        # ovmf = {
        #   enable = true;
        #   packages = [
        #     pkgs.OVMFFull
        #   ];
        # };
      };
    };
    spiceUSBRedirection.enable = true;

  };
  services.spice-vdagentd.enable = true;
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
        #"virbr0"
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
    # inputMethod = {
    #   type = "fcitx5";
    #   enable = true;
    #   fcitx5.addons = with pkgs; [
    #     fcitx5-gtk
    #     fcitx5-chinese-addons
    #     fcitx5-configtool
    #   ];
    # };
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
      #epsonscan2
      epson-escpr2
      gutenprint
    ];
    browsing = true;
  };

  services.open-webui = {
    enable = false;
    host = "0.0.0.0";
    openFirewall = true;
  };
  services.ollama = {
    enable = false;
    package = pkgs.ollama-rocm;
  };

  # hardware.sane = {
  #   enable = true;
  #   extraBackends = [
  #     pkgs.hplipWithPlugin
  #     pkgs.sane-airscan
  #     # (pkgs.epsonscan2.override { withNonFreePlugins = true; })
  #   ];
  #   openFirewall = true;
  # };
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
      "tty"
      "adbusers"
      "dialout"
      "corectrl"
      "networkmanager"
      "video"
      "audio"
      "input"
      "libvirtd"
      "netdev"
      "ubridge"
      "pipewire"
      "realtime"
      "plugdev"
      "gamemode"
    ]; # Groups
    # shell = pkgs.nushell;
    #TODO Set up secret management with sops-nix
  };

  services.tinyproxy = {
    enable = true;
    settings = {
      Port = 8888;
      Listen = "0.0.0.0";

    };
  };

  services.searx = {
    enable = true;
    # redisCreateLocally
    settings = {
      server = {
        secret_key = "DUMMYKEY";
        bind_address = "0.0.0.0";
        port = 8889;
      };
      search.formats = [
        "html"
        "json"
      ];
    };
  };

  #users.users.root.initialPassword = "pass";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = false;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    interfaces."alarkPC".allowedTCPPorts = [
      8889
      8888
    ];
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
      8266
      53
      67
    ];
    trustedInterfaces = [
      "waydroid0"
    ];
    checkReversePath = "loose";
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
