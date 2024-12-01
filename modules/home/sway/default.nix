{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.pluto.desktop.sway;
  modr = "Mod4";
in
#display1 = "DP-1" #Acer
#display2= "DP-2" #Alienware
{
  options.pluto.desktop.sway.enable = mkEnableOption "Enable Sway HomeManager" // {
    default = false;
  };

  config = mkIf cfg.enable {
    #Sway specific

    xdg.portal.enable = true;
    xdg.portal.configPackages = with pkgs; [ xdg-desktop-portal-wlr ];
    #xdg.portal.config.common.default =;
    xdg.portal.config = {

      common = {
        default = [
          "wlr"
        ];

        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };

    };
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal
      gnome-keyring
    ];
    #xdg.portal.xdgOpenUsePortal = true;
    wayland.windowManager.sway = {
      #General Config
      enable = true;
      systemd.enable = true;
      #      extraConfig = ''
      #seat "seat1" {
      #fallback true
      #attach 5426:545:Razer_Razer_BlackWidow_Chroma_V2
      #attach 5426:143:Razer_Naga_Pro
      #}
      #seat "seat2" {
      #attach 7247:2:SIGMACHIP_USB_Keyboard_Consumer_Control
      #attach 7247:2:SIGMACHIP_USB_Keyboard_System_Control
      #attach 7247:2:SIGMACHIP_USB_Keyboard
      #attach 0:0:OpenTabletDriver_Virtual_Artist_Tablet
      #attach 0:0:OpenTabletDriver_Virtual_Tablet
      #attach 0:0:OpenTabletDriver_Virtual_Keyboard
      #attach 0:0:OpenTabletDriver_Virtual_Mouse
      #xcursor_theme VimixCursors-White
      #        }'';
      config = {

				startup = [
					{command="fcitx5 -d -r";}
					{command="fcitx5-remote -r";}
				];
        keybindings = lib.mkOptionDefault {
          "${modr}+Return+Shift" = "exec ${pkgs.kitty}/bin/kitty";
          "${modr}+Return+Ctrl" = "exec slurp | grim -g - /home/alark/Pictures/swayshots/$(date -u +%4Y%2m%2d_%2Hh%2Mm%2Ss_swayshot.png)";
          "${modr}+S+Shift" = "exec slurp | grim -g - - | wl-copy";
          #"${modr}+Tab+Shift" = "swaymsg output DP-2
					"XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
					"XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
					"XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
					"XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
					"XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
					"XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
					"XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
					"XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
					"XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
					#"XF86Launch3" = d
        };
        focus = {
          followMouse = "yes";
          #mouseWrapping = true;
          newWindow = "urgent";
          wrapping = "workspace";

        };
        #Homemanager doesn't allow for multiple 'attach' statements which is annoying
        #So we use extra config for seats entirely
        #seat = { 

        # "seat1" = {
        #attach = ["7247:2:SIGMACHIP_USB_Keyboard_Consumer_Control" "7247:2:SIGMACHIP_USB_Keyboard" ];
        #attach = "7247:2:SIGMACHIP_USB_Keyboard_Consumer_Control";
        #};
        #"seat1" = {
        #  attach =;
        #};

        #"seat1" = {
        #  attach = "7247:2:SIGMACHIP_USB_Keyboard_System_Control";
        #};
        #"seat1" = {
        #  attach = "0:0:OpenTabletDriver_Virtual_Artist_Tablet";
        #};
        #"seat1" = {
        #  attach = "0:0:OpenTabletDriver_Virtual_Tablet";
        #};
        #};

        #Bar Specific, why we use a list of submodules like this is beyond me
        bars = [
          (
            {
              mode = "dock";
              position = "top";
              hiddenState = "hide";
              command = "waybar"; # Need waybar
              #statusCommand = "i3status"; #need i3status we dont need this

            }
            // config.lib.stylix.sway.bar
          )
        ];

        #Colors, we are using Stylix so this *should* be not used
        #colors = {};
        #For all those gaps
        gaps = {
          inner = 4;
        };

        modifier = modr;
        defaultWorkspace = "workspace number 1";
        menu = "tofi-run | xargs swaymsg exec --";
        output = {
          DP-1 = {
            # Acer
            mode = "2560x1440@179.877Hz";
            pos = "3440 0";
            adaptive_sync = "on";
          };
          DP-2 = {
            # Alienware
            mode = "3440x1440@174.963Hz";
            pos = "0 0";
            adaptive_sync = "off";
            render_bit_depth = "10";
          };
					eDP-2 = {
						mode="1920x1200@165.000Hz";
						adaptive_sync="on";
					};
          #HDMI-A-2 = {
          #  mode = "1366x768";
          #  pos = "2560 0";

          #};

        };
        workspaceOutputAssign = [
          {
            output = "DP-1";
            workspace = "10";
          }
          {
            output = "DP-2";
            workspace = "1";
          }
        ];
        window = {
          border = 2;
          #Sway doesnt support window rounding, use hyprland for drip instead
        };
        terminal = "foot";
      };

    };

  };
}
