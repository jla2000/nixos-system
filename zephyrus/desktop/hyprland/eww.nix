{ pkgs, config, ... }:
let
  # Retarded fix to get workspace updates working
  launch-eww = pkgs.writeShellApplication {
    name = "launch-eww.sh";
    text = ''
      eww daemon "$@"
      sleep 2s
      eww open bar "$@"
      sleep 2s
      eww open bar "$@"
    '';
  };
in
{
  home.packages = [
    launch-eww
    pkgs.jq
    pkgs.socat
  ];
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./eww-config;
  };
  wayland.windowManager.hyprland.settings.exec = [
    "eww kill"
    "${launch-eww}/bin/launch-eww.sh"
  ];
}
