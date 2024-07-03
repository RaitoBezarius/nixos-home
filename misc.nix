{ config, pkgs, lib, ... }:
let
  vim-pager = pkgs.writeShellScriptBin "vim-pager" ''
  set -eu

  if [ "$#" -eq 3 ]; then
      INPUT_LINE_NUMBER=''${1:-0}
      CURSOR_LINE=''${2:-1}
      CURSOR_COLUMN=''${3:-1}
      AUTOCMD_TERMCLOSE_CMD="call cursor(max([0,''${INPUT_LINE_NUMBER}-1])+''${CURSOR_LINE}, ''${CURSOR_COLUMN})"
  else
      AUTOCMD_TERMCLOSE_CMD="normal G"
  fi

  exec nvim 63<&0 0</dev/null \
      -u NONE \
      -c "map <silent> q :qa!<CR>" \
      -c "set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus" \
      -c "autocmd TermEnter * stopinsert" \
      -c "autocmd TermClose * ''${AUTOCMD_TERMCLOSE_CMD}" \
      -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b''']8;;file:[^\]*[\]//g" && sleep 0.01 && printf "'$'\x1b''']2;"'
      '';
in
{
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/docs";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pics";
    publicShare = "${config.home.homeDirectory}/publicShare";
    videos = "${config.home.homeDirectory}/videos";
    templates = "${config.home.homeDirectory}/templates";
    extraConfig = {
      XDG_IDENTITY_DIR = "${config.home.homeDirectory}/docs/identity";
      XDG_DEV_DIR = "${config.home.homeDirectory}/dev";
    };
  };

  # Task manager
  programs.taskwarrior = {
    enable = true;
    config = {
      uda.githubtitle.type="string";
      uda.githubtitle.label="Github Title";
      uda.githubbody.type="string";
      uda.githubbody.label="Github Body";
      uda.githubcreatedon.type="date";
      uda.githubcreatedon.label="Github Created";
      uda.githubupdatedat.type="date";
      uda.githubupdatedat.label="Github Updated";
      uda.githubclosedon.type="date";
      uda.githubclosedon.label="GitHub Closed";
      uda.githubmilestone.type="string";
      uda.githubmilestone.label="Github Milestone";
      uda.githubrepo.type="string";
      uda.githubrepo.label="Github Repo Slug";
      uda.githuburl.type="string";
      uda.githuburl.label="Github URL";
      uda.githubtype.type="string";
      uda.githubtype.label="Github Type";
      uda.githubnumber.type="numeric";
      uda.githubnumber.label="Github Issue/PR #";
      uda.githubuser.type="string";
      uda.githubuser.label="Github User";
      uda.githubnamespace.type="string";
      uda.githubnamespace.label="Github Namespace";
      uda.githubstate.type="string";
      uda.githubstate.label="GitHub State";
    };
    colorTheme = "dark-blue-256";
  };
  # home.file.".taskrc".source = /home/raito/dotfiles/.taskrc;

  # Music player
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    extraConfig = ''
      audio_output {
	type		"pulse"
	name		"Local PulseAudio"
      }
    '';
  };
  programs.ncmpcpp.enable = true;
  services.mpdris2.enable = true;

  # Music library
  programs.beets.enable = false;
  # xdg.configFile."beets/config.yaml".source =
  #  lib.mkForce /home/raito/dotfiles/.config/beets/config.yaml;

  # Terminal
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.hack-font;
      name = "Hack";
    };
    keybindings = {
      "f1" = "launch --type overlay --stdin-source=@screen_scrollback ${vim-pager}/bin/vim-pager";
      "f5" = "load_config_file";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
    settings = {
      enable_audio_bell = "no";
      scrollback_pager = "${vim-pager}/bin/vim-pager 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'";
      clipboard_control = "write-clipboard write-primary read-clipboard-ask read-primary-ask";
    };
  };

  # Rootless mounts
  #services.udiskie = {
  #  enable = true;
  #  automount = false;
  #};

  # PDF reader
  programs.zathura.enable = true;

  # Utilities
  programs.jq.enable = true;
  services.flameshot.enable = true;
}
