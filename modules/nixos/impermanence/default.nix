{config,lib,pkgs,...}:
with lib;
let cfg = config.pluto.impermanence;
dir = directory: user: group: mode: {inherit directory user group mode; };
persistentDirectory = "/persist";
in {
  options.pluto.impermanence.enable = mkEnableOption "impermanence";
  config = mkIf cfg.enable (mkMerge [ {
  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir -p /mnt
    mount -o subvol=/ /dev/nvme0n1p2 /mnt

    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root
    umount /mnt
'';
    fileSystems.${persistentDirectory}.neededForBoot = true;
    environment.persistence.${persistentDirectory} = {
      hideMounts = true;
      directories = [
        (dir "/var/lib/bluetooth" "root" "root" "u=rwx,g=,o=")
        (dir "/var/lib/nixos" "root" "root" "u=rwx,g=rx,o=rx")
        (dir "/var/lib/systemd/coredump" "root" "root" "u=rwx,g=rx,o=rx")
        (dir "/etc/NetworkManager/system-connections" "root" "root" "u=rwx,g=,o=")
        (dir "/var/lib/alsa" "root" "root" "u=rwx,g=rx,o=rx")
        (dir "/var/db/sudo" "root" "root" "u=rwx,g=,o=")
        (dir "/etc/fwupd" "root" "root" "u=rwx,g=rx,o=rx")
        (dir "/etc/ssh/authorized_keys.d" "root" "root" "u=rwx,g=,o=")
        (dir "/etc/nix" "root" "root" "u=rwx,g=rx,o=rx")
      ];
      files = [
        "/etc/machine-id"
        "/etc/adjtime"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    }; 
  }
  (mkIf true {
    users.users.alark.hashedPasswordFile = "/persist/passwords/alark";
    programs.fuse.userAllowOther = true;
    environment.persistence.${persistentDirectory} = {
      users.alark = {
        directories = [
          "Downloads"
          "Games"
          ".xlcore"
          "Pictures"
          "Modding"
          "VMs"
          "Development"
          "Documents"
          "Videos"
          ".local/share/direnv"
          ".local/share/Steam"
          ".steam"
          ".config/obs-studio"
          ".mozilla"
          ".config/discord"
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".local/share/keyrings";
            mode = "0700";
          }
        ];
      };
    };
  })
  ]);
}
