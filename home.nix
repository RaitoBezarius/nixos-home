{ config, ... }:
{
  imports = [
    # /home/raito/dev/projects/agenix/modules/hm-age.nix
    ./xorg.nix
    ./sway.nix
    ./shell
    ./emails
    ./theme
    ./calendar
    ./dotfiles.nix
    ./codium.nix
    ./gpg.nix
    ./misc.nix
    ./gotify.nix
    ./xdg.nix
    ./scripts.nix
    ./programs.nix
    ./rtorrent.nix
    ./editor
    ./screen-layouts.nix
    ./compositor.nix
    ./web-browser.nix
    ./screencasting.nix
  ];
 
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "raito";
  home.homeDirectory = "/home/raito";

  # Secrets keys
  # age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa" ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
