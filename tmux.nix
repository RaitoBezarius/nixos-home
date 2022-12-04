{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    prefix = "C-r";
    sensibleOnTop = true;
    terminal = "screen-256color";
    extraConfig = ''
       set-option -g renumber-windows on
    '';
  };
}
