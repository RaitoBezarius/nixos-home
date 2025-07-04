{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Troubleshooting
    iperf3 pciutils 
    # flent
    usbutils
    # Docs
    linux-manual
    glibcInfo
    man-pages
    man-pages-posix
    # Misc
    signal-desktop
    libqalculate
    fd
    fx
    feh
    yq-go
    niv
    pwgen
    git-crypt
    rbw
    pinentry-curses
    gitAndTools.gitFull
    git-lfs
    git-absorb
    git-gr
    hyperfine
    minicom
    picocom
    magic-wormhole-rs
    # TODO (broken): khal
    aerc
    pdftk
    nitrogen
    pandoc
    zotero
    dino
    # prismlauncher # multimc
    pixiecore
    pavucontrol
    easyeffects
    bind
    nixfmt-rfc-style

    tasksh
    taskwarrior-tui
    timewarrior
    python312Packages.bugwarrior
    taskopen

    # TODO (broken): super-slicer
    unzip
    ripgrep
    ripgrep-all
    reflex
    nix-prefetch
    # raito-dev.wireguard-vanity-address
    xournalpp
    evince
    python3
    # raito-dev.uhk-agent
    imapfilter
    # sage
    elan
    drone-cli
    nodePackages.node2nix
    nodePackages.pnpm
    # raito-dev.nodePackages.lean-language-server
    # borgbackup
    libnotify
    fzf
    keyutils
    sieve-connect
    whois
    zip
    alacritty
    tmux
    gdb
    tealdeer
    cheat
    termdown
    # nixos-option
    shellcheck
    # mathlibtools
    gnome-network-displays
    nixpkgs-review

    # Haskell-oriented developement
    # ghc
    # cabal2nix
    # cabal-install
    # haskellPackages.haskell-language-server
    djview
    # ghidra

    # Networking
    # raito-nixpkgs.ripe-atlas-tools
    sipcalc
    ipv6calc
    # ssh3

    # Security
    python312Packages.pynitrokey

    # VNC
    tigervnc

    gh
    tea
    # kicad

    mangohud
    gamemode

    nheko
    evcxr
  ];
}
