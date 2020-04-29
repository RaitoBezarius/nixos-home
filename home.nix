{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # ZSH
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
  };


  # Broot
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  # Browser Pass
  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  # Direnv: must have.
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # Git
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull; # for git send-email
    userEmail = "masterancpp@gmail.com";
    userName = "Raito Bezarius";
  };

  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };
  };

  # TaskWarrior
  programs.taskwarrior = {
    enable = true;
  };

  # Misc
  programs.lesspipe.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
