{
  programs.kitty = {
    enable = true;
    font = {
      name = "MonaspiceNe NFM Bold";
      size = 16;
    };
    environment = {
      TERM = "xterm-256color";
    };
    #theme = "One Dark";
    settings.window_padding_width = 2;
  };
}
