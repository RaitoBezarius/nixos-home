{ config, ... }:
{
  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3status-rs/config-top.toml".source = ./dotfiles/i3status-rs/config-top.toml;
  home.file.".config/i3status-rs/config-bottom.toml".source = ./dotfiles/i3status-rs/config-bottom.toml;
}
