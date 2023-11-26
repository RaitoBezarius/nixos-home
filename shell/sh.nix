{ config, lib, pkgs, ... }: 
let
  fetchFromGitHub = pkgs.fetchFromGitHub;
in
{
  xdg.configFile."zsh/personal".source = ../dotfiles/zsh;
  # age.secrets.work-zshrc.file = ../secrets/work-zshrc.age;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history = { save = 1000000; extended = true; ignoreDups = true; };
    # defaultKeymap = "vicmd";
    initExtra = ''
      setopt extendedglob nomatch notify autopushd
      unsetopt autocd beep

      # export SECRET_ZSHRC="blurb"
      source ${config.xdg.configHome}/zsh/personal/init.zsh
    '';

    shellAliases = {
      agenix = "nix run github:ryantm/agenix --";
      # Jail zoom.
      zoom = "nix-shell -p zoom-us --run \"firejail --private=$HOME/.zoom zoom\"";

      ka = "killall";
      mkd = "mkdir -pv";

      ca = "khal interactive";
      sync_ca = "vsync sync";

      mpv = "mpv --input-ipc-server=/tmp/mpvsoc$(date +%s)";

      dnd = "dunstctl set-paused true";
      nodnd = "dunstctl set-paused false";

      lg = "lazygit";
      g = "git";
      gua = "git remote | xargs -L1 git push --all";

      v = "$EDITOR";
      sdn = "shutdown now";

      irc = ''ssh -t raito@core01.v6.lahfa.xyz "tmux attach"'';
      SU = "systemctl --user";
      SS = "sudo systemctl";

      ffmpeg = "ffmpeg -hide_banner";

      weather = "curl wttr.in";
      v6 = "curl api6.ipify.org";
      v4 = "curl api.ipify.org";
      clbin = "curl -F'clbin=<-' https://clbin.com";
      _0x0 = "curl -F'file=@-' https://0x0.st";

      phs = "python -m http.server";

      ls = "eza";

      rtmv = "rsync -avP";
      archive = "rsync --remove-source-files -avPzz";

      luks_integrity_check = "gocryptfs -fsck -extpass 'pass Private/LUKS' /boot/luks";

      decrypt_playground = "pass Private/Askeladd/Playground/RootLUKS | ssh -p 2222 root@10.32.64.101";

      decrypt_monitoring = "pass Private/Askeladd/Monitoring/LUKS | ssh -p 2222 root@10.32.64.100";

      decrypt_mailserver= "pass Private/Askeladd/Mail/LUKS | ssh root@10.32.64.102 \"cryptsetup-askpass\"";

      decrypt_amadeus = "pass DC1/Amadeus/FDE | ssh -4 -p 2222 root@kurisu.lahfa.xyz";

      fetch-emails = "mbsync --all && notmuch new && afew -t -n -v";

      mpvl = "mpv --loop-file $1";

      sieve-xyz = "pass Private/Mail/V6/ryan@lahfa.xyz | sieve-connect -s kurisu.lahfa.xyz -u ryan@lahfa.xyz";

      tt = "taskwarrior-tui";

      nsp = "nix-shell -p";
      ns = "nix-shell";

      ncg = "sudo nix-collect-garbage --delete-older-than 30d";
      ncga = "sudo nix-collect-garbage -d";
      nso = "sudo nix-store --optimise";

      lln = "NIX_PATH=\"nixpkgs=$LOCAL_NIXPKGS_CHECKOUT\"";
      # Local build
      lnb = "NIX_PATH=\"nixpkgs=$LOCAL_NIXPKGS_CHECKOUT\" nom-build '<nixpkgs>' --no-out-link -A $1";
      # Local shell
      lns = "NIX_PATH=\"nixpkgs=$LOCAL_NIXPKGS_CHECKOUT\" nix-shell -p $1";
      # Local test
      ltt = ''NIX_PATH=\"nixpkgs=$LOCAL_NIXPKGS_CHECKOUT\" nom-build --no-out-link "$LOCAL_NIXPKGS_CHECKOUT/nixos/tests/$1"'';
    };

    dirHashes = {
      nix-hm = "/nix/var/nix/profiles/per-user/$USER/home-manager";
      nix-now = "/run/current-system";
      nix-boot = "/nix/var/nix/profiles/system";
      cfg-sys = "/etc/nixos";
      cfg-mono = "${config.home.homeDirectory}/dev/git.newtype.fr/ryan/nixos-configurations";
      cfg-home = "${config.home.homeDirectory}/dev/git.newtype.fr/ryan/nixos-configurations/home";
      lnixpkgs = "$LOCAL_NIXPKGS_CHECKOUT";
      gh = "${config.home.homeDirectory}/dev/github.com";
      pp = "${config.home.homeDirectory}/dev/github.com/RaitoBezarius";
      ppn = "${config.home.homeDirectory}/dev/git.newtype.fr/ryan";
      ens = "${config.home.homeDirectory}/dev/projects/ens";
      newtype = "${config.home.homeDirectory}/dev/git.newtype.fr";
      nt = "${config.home.homeDirectory}/dev/git.newtype.fr/newtype";
      nc = "${config.home.homeDirectory}/dev/github.com/nix-community";
      detsys = "${config.home.homeDirectory}/dev/github.com/DeterminateSystems";
      nixos = "${config.home.homeDirectory}/dev/github.com/NixOS";
      aggelia = "${config.home.homeDirectory}/dev/git.newtype.fr/ryan/aggelia";
      lanzaboote = "${config.home.homeDirectory}/dev/github.com/nix-community/lanzaboote";
      nix-rfcs = "${config.home.homeDirectory}/dev/github.com/NixOS/rfcs";
    };
    plugins = [
      # https://github.com/idadzie/zsh-presenter-mode
      {
        name = "history-search-multi-word";
        src = fetchFromGitHub {
          repo = "history-search-multi-word";
          owner = "zdharma-continuum";
          rev = "458e75c16db72596e4d7c6a45619dec285ebdcd7";
          sha256 = "sha256-6B8uoKJm3gWmufsnLJzLEdSm1tQasrs2fUmS0pDsdMw=";
        };
      }
      {
        name = "git-aliases";
        src = fetchFromGitHub {
          repo = "git-aliases";
          owner = "mdumitru";
          rev = "c4cfe2cf5cf59a3da6bf3b735a20921a2c06c58d";
          sha256 = "sha256-640qGgVeFaTIQBgYGY05/4wzMCxni0uWLWtByEFM2tE=";
        };
      }
      {
        name = "zsh-bitwarden";
        src = fetchFromGitHub {
          repo = "zsh-bitwarden";
          owner = "Game4Move78";
          rev = "8b32434d18765fe95ffc2191f5fb68100d913de7";
          sha256 = "sha256-3zuutTUSdf218+jcn2z7yEGMYkg5VewXm9zO43aIYdI=";
        };
      }
      {
        name = "alias-tips";
        src = fetchFromGitHub {
          repo = "alias-tips";
          owner = "djui";
          rev = "4d2cf6f10e5080f3273be06b9801e1fd1f25d28d";
          sha256 = "sha256-0N2DCpMraIXtEc7hMp0OBANNuYhHPLqzJ/hrAFcLma8=";
        };
      }
      {
        name = "auto-notify";
        src = fetchFromGitHub {
          repo = "zsh-auto-notify";
          owner = "MichaelAquilina";
          rev = "fb38802d331408e2ebc8e6745fb8e50356344aa4";
          sha256 = "sha256-bY0qLX5Kpt2x4KnfvXjYK2+BhR3zKBgGsCvIxSzApws=";
        };
      }
      {
        name = "nix-shell";
        src = fetchFromGitHub {
          repo = "zsh-nix-shell";
          owner = "chisui";
          rev = "f8574f27e1d7772629c9509b2116d504798fe30a";
          sha256 = "sha256-WNa8RljYhkOWk7AZbdTOvYhWw1fR8PjFxH/tnUCbems=";
        };
      }
      {
        name = "jq";
        src = fetchFromGitHub {
          repo = "jq-zsh-plugin";
          owner = "reegnz";
          rev = "98650d6eac46b5f87aa19f0a3dd321b0105643b8";
          sha256 = "sha256-L2+PW39BZTy8h4yxxZxbKCVVKlfPruM12gRZ9FJ8YD8=";
        };
      }
    ];
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
    nix-direnv.enable = true;
  };

  # Misc
  programs.lesspipe.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
