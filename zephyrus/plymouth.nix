{ config, lib, pkgs, ... }:
{
  options.keepBootLogo = {
    enable = lib.mkEnableOption "Enable plymouth screen";
  };

  config = lib.mkIf config.keepBootLogo.enable {
    boot = {
      loader.timeout = 0;
      consoleLogLevel = 0;
      initrd = {
        systemd.enable = true;
        verbose = false;
      };
      kernelParams = [ "quiet" "splash" "udev.log_level=0" ];
      plymouth = {
        enable = true;
        themePackages = [ pkgs.nixos-bgrt-plymouth ];
        theme = "nixos-bgrt";
      };
    };
  };
}
