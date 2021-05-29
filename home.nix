{ config, pkgs, lib, ... }:
let
  emailUtils = import ./emails/utils.nix { inherit lib; };
in
{
  imports = [
    ./emails
    ./theme
  ];

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

    shellAliases = {
      fetch-emails = "mbsync --all && notmuch new && afew -t -n -v";
      irc = ''ssh -t playground "tmux attach"'';
      SU = "systemctl --user";
      SS = "sudo systemctl";
    };
  };

  programs.gpg = {
    enable = true;
  };

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program = "${pkgs.pinentry_qt5}/bin/pinentry-qt";
  '';

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
    userEmail = emailUtils.obfuscate "moc.liamg@ppcnaretsam";
    userName = emailUtils.obfuscate "suirazeB otiaR";
  };

  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code;
      name = "Fira Code for Powerline";
    };
  };

  # TaskWarrior
  programs.taskwarrior = {
    enable = true;
  };

  # Mako
  programs.mako = {
    enable = true;
    defaultTimeout = 5000;
  };

  # Misc
  programs.lesspipe.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
     "vscode-extension-ms-toolsai-jupyter"
  ];

  home.packages = let
    vscodeExtensions = (with pkgs.vscode-extensions; [
      bbenoist.Nix
      ms-python.python
      redhat.vscode-yaml
      cmschuetz12.wal
      alanz.vscode-hie-server
      justusadam.language-haskell
      vscodevim.vim
      llvm-org.lldb-vscode
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "lean";
      publisher = "jroesch";
      version = "0.16.22";
      sha256 = "08fj7h6dw56s40l9fkn4xz1valxpwhc4n8vw7d44264cabcsmkrw";
    }];
    vscodium-with-extensions = pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      inherit vscodeExtensions;
    };
    all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  in [
    # (all-hies.selection { selector = p: { inherit (p) ghc882 ghc865; }; })
    vscodium-with-extensions
    pkgs.lesspipe
  ];


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
