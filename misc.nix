{ config, pkgs, lib, ... }:
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
  programs.beets.enable = true;
  # xdg.configFile."beets/config.yaml".source =
  #  lib.mkForce /home/raito/dotfiles/.config/beets/config.yaml;

  # Terminal
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.hack-font;
      name = "Hack";
    };
    settings = {
      enable_audio_bell = "no";
    };
  };

  # Rootless mounts
  services.udiskie = {
    enable = true;
    automount = false;
  };

  # PDF reader
  programs.zathura.enable = true;

  # Utilities
  programs.jq.enable = true;
  programs.lazygit.enable = true;
  services.flameshot.enable = true;
}
