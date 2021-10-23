{ config, pkgs, lib, ... }:
let
  w3m-bin = "${pkgs.w3m}/bin/w3m";
  sxiv-bin = "${pkgs.sxiv}/bin/w3m";
  zathura-bin = "${pkgs.zathura}/bin/w3m";
  pipe-to-browser-bin = "${pkgs.writeShellScriptBin "pipe-to-browser.sh" ''
  #!/usr/bin/env bash
  if [ -t 0 ]; then
    if [ -n "$1" ]; then
      xdg-open $1
    else
      cat <<usage
  Usage: browser
         pipe html to a browser
  $ echo '<h1>hi mom!</h1>' | browser
  $ ron -5 man/rip.5.ron | browser
  usage
  fi
  else
    f="/tmp/browser.$RANDOM.html"
    cat /dev/stdin > $f
    xdg-open $f
  fi
  ''}/bin/pipe-to-browser.sh";
  lesspipe = let
    mkDirective = mimetype: "${mimetype}; LESSQUIET=1 ${pkgs.lesspipe}/bin/lesspipe.sh '%s'; copiousoutput";
  in
  ''
    ${mkDirective "application/*"}
    ${mkDirective "image/*"}
    ${mkDirective "audio/*"}
  '';
  importcal-bin = "${pkgs.writeShellScriptBin "print_and_import_cal.sh" ''
    ${builtins.readFile ./print_and_import_cal.sh}
  ''}/bin/print_and_import_cal.sh";
in
{
  home.file.".config/mailcap" = {
    text = ''
      ${lesspipe}
      text/html; ${pipe-to-browser-bin} '%s'; test=test -n "$DISPLAY"
      application/pdf; ${zathura-bin} '%s'; test=test -n "$DISPLAY"
      application/x-pdf; ${zathura-bin} '%s'; test=test -n "$DISPLAY"
      application/ics; ${importcal-bin} '%s'
      text/calendar; ${importcal-bin} '%s'
    '';
  };
}
