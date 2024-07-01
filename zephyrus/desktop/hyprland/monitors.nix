{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types mkIf;
in
{
  options.monitors = mkOption {
    type = types.listOf
      (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
          };
          mode = mkOption {
            type = types.str;
            example = "1920x1080@60";
          };
          position = mkOption {
            type = types.str;
            example = "auto";
          };
          scale = mkOption {
            type = types.float;
            example = 1.0;
          };
        };
      });
    default = [ ];
  };

  config =
    let
      monitorStr = m: "${m.name},${m.mode},${m.position},${toString m.scale}";
      primary-monitor = builtins.elemAt config.monitors 0;
      toggle-lid = pkgs.writeShellApplication {
        name = "toggle-lid.sh";
        text = ''
          if grep open /proc/acpi/button/lid/LID/state; then
            hyprctl keyword monitor ${monitorStr primary-monitor}
          else
            if [[ $(hyprctl monitors | grep -c "Monitor") != 1 ]]; then
              hyprctl keyword monitor "${primary-monitor.name},disable"
            fi
          fi
        '';
      };
    in
    mkIf (builtins.length config.monitors > 0)
      {
        wayland.windowManager.hyprland.settings = {
          monitor = map monitorStr config.monitors;
          bindl = ", switch:Lid Switch, exec, ${toggle-lid}/bin/toggle-lid.sh";
        };
      };
}
