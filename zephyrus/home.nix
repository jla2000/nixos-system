{ config, inputs, ... }:
{
  imports = [
    ./apps
    ./desktop/i3
    inputs.nixos-dotfiles.homeManagerModules.neovim
    inputs.nixos-dotfiles.homeManagerModules.zellij
  ];

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
  };

  programs.git = {
    enable = true;
    userName = "Jan Lafferton";
    userEmail = "jan@lafferton.de";
    extraConfig = {
      pull.rebase = true;
    };
  };

  home.sessionVariables.FLAKE = "${config.home.homeDirectory}/code/nixos-zephyrus";
  home.stateVersion = "24.11";
}
