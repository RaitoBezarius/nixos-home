{ config, pkgs, lib, ... }: {
  xdg.dataFile."applications/neomutt.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=neomutt-desktop
    Categories=Email
    Exec=${pkgs.kitty}/bin/kitty -T Email neomutt %u
    StartupNotify=true
    MimeType=x-scheme-handler/mailto;
  '';

  xdg.mimeApps.defaultApplications."x-scheme-handler/mailto" =
    [ "neomutt.desktop" ];
}
