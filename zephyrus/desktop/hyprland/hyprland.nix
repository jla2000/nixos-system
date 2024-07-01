{ pkgs, lib, config, ... }:
{
  options.mod = lib.mkOption {
    default = "WIN";
    type = lib.types.string;
  };

  config = {
    home.packages = with pkgs; [
      brightnessctl
      wl-clipboard
      rofi-wayland
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Enable variable refresh rate
        misc = {
          vfr = true;
          vrr = 1;
        };

        # Keybindings
        bind =
          [
            # General
            "${config.mod}, Return, exec, kitty"
            "${config.mod}, F, exec, firefox"
            "${config.mod}, R, exec, rofi -show drun"
            "${config.mod} SHIFT, Q, killactive"
            "${config.mod}, V, togglefloating"

            # Workspaces
            "${config.mod}, 1, workspace, 1"
            "${config.mod}, 2, workspace, 2"
            "${config.mod}, 3, workspace, 3"
            "${config.mod}, 4, workspace, 4"
            "${config.mod}, 5, workspace, 5"
            "${config.mod}, 6, workspace, 6"
            "${config.mod}, 7, workspace, 7"
            "${config.mod}, 8, workspace, 8"
            "${config.mod}, 9, workspace, 9"
            "${config.mod}, 0, workspace, 10"
            "${config.mod} SHIFT, 1, movetoworkspace, 1"
            "${config.mod} SHIFT, 2, movetoworkspace, 2"
            "${config.mod} SHIFT, 3, movetoworkspace, 3"
            "${config.mod} SHIFT, 4, movetoworkspace, 4"
            "${config.mod} SHIFT, 5, movetoworkspace, 5"
            "${config.mod} SHIFT, 6, movetoworkspace, 6"
            "${config.mod} SHIFT, 7, movetoworkspace, 7"
            "${config.mod} SHIFT, 8, movetoworkspace, 8"
            "${config.mod} SHIFT, 9, movetoworkspace, 9"
            "${config.mod} SHIFT, 0, movetoworkspace, 10"

            # Focus
            "${config.mod}, H, movefocus, l"
            "${config.mod}, L, movefocus, r"
            "${config.mod}, J, movefocus, d"
            "${config.mod}, K, movefocus, u"

            # Media keys
            ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
            ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
            ", XF86AudioLowerVolume, exec, amixer set Master 5%-"
            ", XF86AudioRaiseVolume, exec, amixer set Master 5%+"
            ", XF86AudioMicMute, exec, amixer set Capture toggle"
            ", XF86KbdBrightnessDown, exec, asusctl --prev-kbd-bright"
            ", XF86KbdBrightnessUp, exec, asusctl --next-kbd-bright"
            ", XF86Launch3, exec, asusctl led-mode --next-mode"
            ", XF86Launch1, exec, rog-control-center"
          ];

        # Mouse bindings
        bindm = [
          "${config.mod}, mouse:272, movewindow"
          "${config.mod}, mouse:273, resizewindow"
        ];

        # Window styling
        decoration = {
          rounding = 10;
        };

        # Disable annoying animations
        animations = {
          enabled = false;
        };

        general = {
          border_size = 2;
          sensitivity = 0.3;
          gaps_out = 10;
        };

        input = {
          touchpad = {
            clickfinger_behavior = true;
          };

          # Snappy keys
          repeat_rate = 30;
          repeat_delay = 200;
        };
      };
    };
  };
}
