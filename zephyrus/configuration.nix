# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, lib, config, pkgs, outputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./plymouth.nix
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402
  ];

  services.logind.lidSwitch = "suspend-then-hibernate";
  boot.resumeDevice = "/dev/disk/by-uuid/014ae8e5-6052-4520-a3e8-dd19a9dcbcce";

  # Configure boot loader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # Nice boot logo :)
  keepBootLogo.enable = true;

  # Allow switching graphics card
  services.supergfxd.enable = true;

  # Use zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Configure networking
  networking.hostName = "zephyrus";
  networking.networkmanager.enable = true;

  # Configure locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure sound and video
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Configure xserver settings
  environment.pathsToLink = [ "/libexec" ];

  # Configure login manager and window manager
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    desktopManager.xterm.enable = false;

    displayManager = {
      defaultSession = "none+i3";
      gdm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status-rust
        i3lock
        i3blocks
        networkmanagerapplet
        dunst
        brightnessctl
        libnotify
      ];
    };

    config = /* xorg */ ''
      Section "Device"
        Identifier     "AMD"
        Option         "VariableRefresh"   "true"
        Option         "TearFree"          "true"
      EndSection
    '';
    exportConfiguration = true;
  };

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Keep system clean and up to date
  nix.gc.automatic = true;
  system.autoUpgrade = {
    enable = true;
    flake = "github:jla2000/nixos-dotfiles";
  };

  # Automatic btrfs scrub
  services.btrfs.autoScrub.enable = lib.mkDefault
    (builtins.any (filesystem: filesystem.fsType == "btrfs")
      (builtins.attrValues config.fileSystems));

  # Default user
  users.users.jan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    gcc
    git
    gnumake
    htop
    killall
    libreoffice-fresh
    neofetch
    neovide
    nodejs
    pciutils
    spotify
    thunderbird
    unzip
    ventoy-full
    xclip
  ];

  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Install some nice fonts
  fonts.packages = [
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraMono"
        "JetBrainsMono"
        "Monaspace"
      ];
    })
    pkgs.monaspace
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

