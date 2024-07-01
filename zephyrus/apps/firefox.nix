{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        settings = {
          "layout.css.devPixelsPerPx" = "1.25";
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          vimium
          firenvim
          darkreader
        ];
      };
    };
  };
}
