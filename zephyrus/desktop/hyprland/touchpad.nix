{ config, lib, pkgs, ... }:
{
  options = {
    touchpad-device = lib.mkOption {
      type = lib.types.str;
      default = null;
    };
  };

  config =
    let
      enable-property = "device:${config.touchpad-device}:enabled";
      timeout-property = "general:cursor_inactive_timeout";
      toggle-touchpad = pkgs.writeShellApplication {
        name = "toggle-touchpad.sh";
        text = ''
          if hyprctl getoption ${enable-property} | grep -q "int: 1"; then
          	hyprctl keyword ${enable-property} false
          	hyprctl keyword ${timeout-property} 1
          else
          	hyprctl keyword ${enable-property} true
          	hyprctl keyword ${timeout-property} 0
          fi
        '';
      };
    in
    lib.mkIf (config.touchpad-device != null)
      {
        wayland.windowManager.hyprland.settings.bind = [
          ", XF86TouchpadToggle, exec, ${toggle-touchpad}/bin/toggle-touchpad.sh"
        ];
      };
}
