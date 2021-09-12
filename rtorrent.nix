{ config, pkgs, lib, ... }: {
  programs.rtorrent.enable = true;

  xdg.dataFile."applications/rtorrent-magnet.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=rtorrent-magnet
    Exec=open-magnet %U
    MimeType=x-scheme-handler/magnet;
    NoDisplay=true
  '';

  xdg.mimeApps.defaultApplications."x-scheme-handler/magnet" =
    [ "rtorrent-magnet.desktop" ];

  home.packages = [
    (pkgs.writeScriptBin "open-magnet" ''
      #!${pkgs.stdenv.shell}
      watch_folder=~/.rtorrent/watch
      cd $watch_folder
      [[ "$1" =~ xt=urn:btih:([^&/]+) ]] || exit;
      echo "d10:magnet-uri''${#1}:''${1}e" > "meta-''${BASH_REMATCH[1]}.torrent"
      ${pkgs.noti}/bin/noti -t "magnetizer" -m "added magnet link to $watch_folder"
    '')
  ];
}
