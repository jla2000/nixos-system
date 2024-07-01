{ pkgs, lib, config, ... }:
let
  cfg = config.cursor;
in
{
  options.cursor = {
    package = lib.mkOption {
      default = pkgs.bibata-cursors;
      type = lib.types.package;
    };
    theme = lib.mkOption {
      default = "Bibata-Modern-Classic";
      type = lib.types.string;
    };
    size = lib.mkOption {
      default = 24;
      type = lib.types.int;
    };
  };

  config = {
    home.pointerCursor = {
      gtk.enable = true;
      package = cfg.package;
      name = cfg.theme;
      size = cfg.size;
    };

    gtk = {
      enable = true;
    };

    wayland.windowManager.hyprland.settings.exec-once = [
      "hyprctl setcursor ${cfg.theme} ${toString cfg.size}"
    ];
  };
}
