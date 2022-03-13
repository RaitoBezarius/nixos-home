{ config, pkgs, ... }: 
let
  fetchFromGitHub = pkgs.fetchFromGitHub;
in
{
  xdg.configFile."zsh/personal".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/zsh;
  age.secrets.work-zshrc.file = ../secrets/work-zshrc.age;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history = { save = 100000; extended = true; ignoreDups = true; };
    # defaultKeymap = "vicmd";
    initExtra = ''
      setopt extendedglob nomatch notify
      unsetopt autocd beep

      export SECRET_ZSHRC="${config.age.secrets.work-zshrc.path}"
      source ${config.xdg.configHome}/zsh/personal/init.zsh
    '';

    shellAliases = {
      agenix = "nix run github:ryantm/agenix --";

      # TODO: write up a generic solution for network-based sandboxing.
      chackens = "firejail --x11 --netns=hackens --dns=192.168.1.1 --private-bin=chromium --private --private-tmp --noprofile chromium http://hackens-desktop1.lan:5000";

      # Jail zoom.
      zoom = "nix-shell -p zoom-us --run \"firejail --private=$HOME/.zoom zoom\"";

      ka = "kilall";
      mkd = "mkdir -pv";

      ca = "khal interactive";
      sync_ca = "vdirsyncer sync";

      mpv = "mpv --input-ipc-server=/tmp/mpvsoc$(date +%s)";

      dnd = "dunstctl set-paused true";
      nodnd = "dunstctl set-paused false";

      lg = "lazygit";
      g = "git";
      gua = "git remote | xargs -L1 git push --all";

      v = "$EDITOR";
      sdn = "shutdown now";

      irc = ''ssh -t playground "tmux attach"'';
      SU = "systemctl --user";
      SS = "sudo systemctl";

      ffmpeg = "ffmpeg -hide_banner";

      weather = "curl wttr.in";
      v6 = "curl api6.ipify.org";
      v4 = "curl api.ipify.org";

      ls = "exa";

      rtmv = "rsync -avP";
      archive = "rsync --remove-source-files -avPzz";

      luks_integrity_check = "gocryptfs -fsck -extpass 'pass Private/LUKS' /boot/luks";

      decrypt_playground = "pass Private/Askeladd/Playground/RootLUKS | ssh -p 2222 root@10.32.64.101";

      decrypt_monitoring = "pass Private/Askeladd/Monitoring/LUKS | ssh -p 2222 root@10.32.64.100";

      decrypt_mailserver= "pass Private/Askeladd/Mail/LUKS | ssh root@10.32.64.102 \"cryptsetup-askpass\"";

      fetch-emails = "mbsync --all && notmuch new && afew -t -n -v";

      mpvl = "mpv --loop-file $1";

      phub = "nix-prefetch fetchFromGitHub";

      sieve-xyz = "pass Private/Mail/V6/ryan@lahfa.xyz | sieve-connect -s kurisu.lahfa.xyz -u ryan@lahfa.xyz";

      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
    };

    dirHashes = {
      nix-hm = "/nix/var/nix/profiles/per-user/$USER/home-manager";
      nix-now = "/run/current-system";
      nix-boot = "/nix/var/nix/profiles/system";
      cfg-sys = "/etc/nixos";
      cfg-home = "${config.home.homeDirectory}/dev/projects/personal-configuration/nixos-home";
      ens = "${config.home.homeDirectory}/dev/projects/ens";
      newtype = "${config.home.homeDirectory}/dev/projects/newtype";
    };
    plugins = [
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
  };

  # Misc
  programs.lesspipe.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
