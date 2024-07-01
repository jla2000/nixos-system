{ config, pkgs, lib, ... }:
let
  change-wallpaper = pkgs.writeShellApplication {
    name = "change-wallpaper.sh";
    text = ''
      wal -i ${config.wallpaper}
      swww img "$(cat ~/.cache/wal/wal)" --transition-type grow --transition-fps 120
    '';
  };
in
{
  options = {
    wallpaper = lib.mkOption {
      default = ./wallpapers;
      type = lib.types.path;
    };
  };

  config = {
    home.packages = [
      pkgs.swww
      pkgs.pywal
      change-wallpaper
    ];
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "swww init"
        "${change-wallpaper}/bin/change-wallpaper.sh"
      ];
      bind = [
        "${config.mod} SHIFT, W, exec, ${change-wallpaper}/bin/change-wallpaper.sh"
      ];
    };
  };
}
