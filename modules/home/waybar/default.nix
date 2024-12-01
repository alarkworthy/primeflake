{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.waybar;
in
{
  options.pluto.desktop.waybar.enable = mkEnableOption "Enable Waybar" // {
    default = config.pluto.desktop.sway.enable;
  };
	options.pluto.home.system = mkOption {
		type = lib.types.str;
		default = "Desktop";
		example = "Laptop";
		description = "System type for home manager";
	};
  config = mkIf cfg.enable {
    #Waybar time
    programs.waybar = {
      enable = true;
      style = ''
                      *{
                	 border-radius: 0;
                	 font-size: 16px;
                	 min-height: 0;
                       }
                       #workspaces button {
                         background: transparent;
                	 border-top: 2px solid transparent;
                	 min-width: 4px;
                       }
        							#clock,
        							#battery,
        							#cpu,
        							#memory,
        							#disk,
        							#temperature,
        							#backlight,
        							#network,
        							#pulseaudio,
        							#wireplumber,
        							#custom-media,
        							#tray,
        							#mode,
        							#idle_inhibitor,
        							#scratchpad,
        							#power-profiles-daemon,
        							#mpd {
        								padding: 0 10px;
        							}
                      
        							#keyboard-state {
        								padding: 0 0px;
        								margin: 0 5px;
        								min-width: 16px;
        							}
        							#keyboard-state > label {
        								padding: 0 5px;
        							}

      '';
      #Systemd importing and launching #Turned off bc waybar is stupid
      systemd = {
        enable = false;
        target = "sway-session.target";
      };
      settings = {
        #Bar 1, mainbar for now
        mainBar = {
          layer = "top";
          position = "top";
          mode = "dock";
          ipc = "true";
          #id = "bar-0";
          #height = 30;
          #spacing = 6;
          modules-left = [
            "user"
            "sway/workspaces"
          ];
          modules-center = [ "sway/window" ];
          modules-right = [
            "tray"
            "pulseaudio"
            "network"
            "keyboard-state"
            "cpu"
            "memory"
            "temperature"
            "sway/langauge"
            "clock"
            "battery"
          ];

          "network" = {
            #interface = "wlo1";
            format-wifi = "{essid} ({signalStrength}%)";
            format-ethernet = "{ipaddr}/{cidr}";
            tooltip-format = "{ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}";
            interval = 60;
          };

          "sway/window" = {
            format = "{title}";
            max-length = 50;
            #tooltip = true;
            #tooltip-format ="{shell} | {app_id}";
            all-outputs = false;
            offscreen-css = false;
            icon = false;
            icon-size = 24;
          };

          "sway/workspaces" = {
            all-outputs = false;
            format = "{value}";
          };

          "user" = {
            format = "alarky uwu";
            height = 20;
            width = 20;
            icon = true;
            avatar = "${./avatars/discordAvatar}";
          };

          "battery" = {
            states = {
              good = 95;
              warning = 20;
              critical = 10;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-full = "";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          #"langauge" = {}; use default
          #"pulseaudio" I like the default currently lol

          #cpu Leaving as default

          #disk We don't really need this tbh, leaving since it is supported by stylix

          #clock WTF, we are using default for now bc this has too much stuff lol

          #buttons!!

          "keyboard-state" = {
            numlock = true;
						  capslock = true;
            format = {
              numlock = "N {icon}";
              capslock = "C {icon}";
            } //
						(mkIf (config.pluto.home.system == "Desktop") {device-path="/dev/input/by-id/usb-Razer_Razer_BlackWidow_Chroma_V2-event-kbd";});

            format-icons = {
              locked = "";
              unlocked = "";
            };

          };

          #"bluetooth" = {
          #  format =
          #};

          "tray" = {
            spacing = 10;
          };

          "memory" = {
            format = "{}% ";
          };

          "cpu" = {
            format = "{usage}% 󰻠";
          };

          "temperature" = {
            interval = 10;
            format = "{temperatureC}°C ";
            format-critical = "HOT!! {temperatureC}°C ";
            critical-threshold = 80;
            tooltip = true;
            tooltip-format = "{temperatureF}°F";
          } // (mkIf (config.pluto.home.system == "Desktop"){hwmon-path="/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input";});

          "pulseaudio" = {
            format = "{volume}% {format_source}";
            on-click = "pavucontrol";
          };
          #Use this to adjust shadows and border rounding, stylix handles colors
        };
      };
    };
    home.packages = with pkgs; [
      pavucontrol
    ];
  };
}
