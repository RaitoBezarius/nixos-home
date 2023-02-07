{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Troubleshooting
    iperf3 pciutils
    usbutils
    # Misc
    signal-desktop
    fd
    fx
    feh
    yq-go
    niv
    git-crypt
    bitwarden-cli
    gitAndTools.gitFull
    git-lfs
    # TODO (broken): khal
    aerc
    pdftk
    nitrogen
    pandoc
    zotero
    # dino
    prismlauncher # multimc
    pixiecore
    pavucontrol
    easyeffects
    bind
    nixfmt
    tasksh
    taskwarrior-tui
    # TODO (broken): super-slicer
    unzip
    ripgrep
    reflex
    nix-prefetch
    # raito-dev.wireguard-vanity-address
    xournal
    evince
    python3
    # raito-dev.uhk-agent
    imapfilter
    python3Packages.vdirsyncer
    # sage
    elan
    drone-cli
    nodePackages.node2nix
    nodePackages.pnpm
    # raito-dev.nodePackages.lean-language-server
    borgbackup
    python39Packages.percol
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
    nixos-option
    shellcheck
    # mathlibtools
    gnome-network-displays
    nixpkgs-review

    # Haskell-oriented developement
    ghc
    cabal2nix
    cabal-install
    haskellPackages.haskell-language-server
    djview
    ghidra

    # Networking
    # raito-nixpkgs.ripe-atlas-tools
    sipcalc
    ipv6calc

    gh
    tea
  ];
}
