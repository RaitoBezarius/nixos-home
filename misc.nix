{ pkgs, lib, ... }:
{
  # Task manager
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-blue-256";
  };
  home.file.".taskrc".source = /home/raito/dotfiles/.taskrc;

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
  xdg.configFile."beets/config.yaml".source =
    lib.mkForce /home/raito/dotfiles/.config/beets/config.yaml;

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
