{ config, pkgs, ... }: {
  xdg.configFile."zsh/personal".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/zsh;
  age.secrets.work-zshrc.file = ../secrets/work-zshrc.age;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history = { save = 100000; extended = true; ignoreDups = true; };
    defaultKeymap = "vicmd";
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
    };

    dirHashes = {
      nix-hm = "/nix/var/nix/profiles/per-user/$USER/home-manager";
      nix-now = "/run/current-system";
      nix-boot = "/nix/var/nix/profiles/system";
      cfg-home = "~/dev/projects/personal-configuration/nixos-home";
      ens = "~/dev/projects/ens";
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
