{ config, ... }:
{
  home.file.".config/sway/config".source = ./dotfiles/sway;
  home.file.".config/waybar/config".source = ./dotfiles/waybar/config;
  home.file.".config/waybar/style.css".source = ./dotfiles/waybar/style.css;

  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3status-rs/config-top.toml".source = config.lib.file.mkOutOfStoreSymlink ./dotfiles/i3status-rs/config-top.toml;
  home.file.".config/i3status-rs/config-bottom.toml".source = config.lib.file.mkOutOfStoreSymlink ./dotfiles/i3status-rs/config-bottom.toml;
}
