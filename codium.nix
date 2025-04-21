{ config, pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default.extensions = (with pkgs.vscode-extensions; [
      bbenoist.nix
      redhat.vscode-yaml
      cmschuetz12.wal
      alanz.vscode-hie-server
      justusadam.language-haskell
      vscodevim.vim
      # llvm-org.lldb-vscode
      alygin.vscode-tlaplus
    ]);

    profiles.default.userSettings = {
      "window.zoomLevel" = 1;
      "workbench.colorTheme" = "Default High Contrast"; 
      "tlaplus.java.home" = "${pkgs.jdk11_headless}";
    };
  };
}
