{ lib, config, osConfig, ... }:
{
  home.file.".config/sway/config".source = config.lib.file.mkOutOfStoreSymlink ./dotfiles/sway;
  home.file.".config/waybar/config".source = ./dotfiles/waybar/config;
  home.file.".config/waybar/style.css".source = ./dotfiles/waybar/style.css;

  services.kanshi = lib.mkIf (osConfig.my.display-server == "wayland") {
    enable = true;
  };
}
