{ pkgs, ... }:
{
  home.packages = with pkgs; [
    signal-desktop
    fd
    yq-go
    niv
    git-crypt
    gitAndTools.gitFull
    git-lfs
    khal
    aerc
    pdftk
    nitrogen
    pandoc
    zotero
    # dino
    multimc
    pixiecore
    pavucontrol
    pulseeffects-pw
    bind
    nixfmt
    tasksh
    super-slicer
    unzip
    ripgrep
    reflex
    nix-prefetch
    # raito-dev.wireguard-vanity-address
    xournal
    evince
    python3
    poetry
    # raito-dev.uhk-agent
    imapfilter
    python38Packages.vdirsyncer
    sage
    elan
    drone-cli
    nodePackages.node2nix
    raito-dev.nodePackages.lean-language-server
    borgbackup
  ];
}
