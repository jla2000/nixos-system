{ lib, pkgs, ... }:
let
  mod = "Mod4";
  fonts = {
    names = [ "MonaspiceNe NFM" ];
    style = "bold";
    size = 13.0;
  };
  toggle-touchpad = pkgs.writeShellApplication {
    name = "toggle-touchpad.sh";
    text = ''
      if xinput list-props 13 | grep "Device Enabled (.*):.*1" >/dev/null
      then
        xinput disable 13
        notify-send -u low -i mouse "Touchpad disabled"
      else
        xinput enable 13
        notify-send -u low -i mouse "Touchpad enabled"
      fi
    '';
  };
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      inherit fonts;
      modifier = mod;
      terminal = "kitty";
      startup = [
        { command = "nm-applet"; }
        { command = "blueman-applet"; }
        { command = "dunst"; }
      ];
      bars = [
        {
          inherit fonts;
          position = "bottom";
          statusCommand = "i3status-rs ${./i3status-rust.toml}";
        }
      ];
      keybindings = lib.mkOptionDefault {
        "${mod}+c" = "exec firefox";

        # Navigation
        "${mod}+h" = "focus left";
        "${mod}+l" = "focus right";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";

        # Media keys
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86AudioLowerVolume" = "exec amixer set Master 5%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 5%+";
        "XF86AudioMicMute" = "exec amixer set Capture toggle";
        "XF86KbdBrightnessDown" = "exec asusctl --prev-kbd-bright";
        "XF86KbdBrightnessUp" = "exec asusctl --next-kbd-bright";
        "XF86Launch3" = "exec asusctl led-mode --next-mode";
        "XF86Launch1" = "exec rog-control-center";
        "XF86TouchpadToggle" = "exec ${toggle-touchpad}/bin/toggle-touchpad.sh";
      };
    };
  };
}
