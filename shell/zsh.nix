{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history = {
      save = 100000;
    };
    defaultKeymap = "vicmd";
    initExtra = ''
      setopt extendedglob nomatch notify
      unsetopt autocd beep
    '';

    shellAliases = {
      fetch-emails = "mbsync --all && notmuch new && afew -t -n -v";
      irc = ''ssh -t playground "tmux attach"'';
      SU = "systemctl --user";
      SS = "sudo systemctl";
    };
  };

  # Broot
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  # Direnv: must have.
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # Misc
  programs.lesspipe.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
