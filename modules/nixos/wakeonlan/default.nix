{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.pluto.wakeOnLan.enable = lib.mkEnableOption "WakeOnLan";
  options.pluto.wakeOnLan.interface = lib.mkOption {
    type = lib.types.str;
    default = "";
    example = "enp113s0";
    description = "Determines the interface to enable wake on lan for";
  };
  config = lib.mkIf config.pluto.wakeOnLan.enable {
    systemd.services."wakeOnLanScript" = {
      description = "Wake-on-lan";
      unitConfig = {
        Requires = "network.target";
        After = "network.target";
      };
      serviceConfig = {
        ExecStart = "${pkgs.ethtool}/bin/ethtool -s ${config.pluto.wakeOnLan.interface} wol g";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
