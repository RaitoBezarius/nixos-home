{ config, pkgs, lib, ... }:
let
  w3m-bin = "${pkgs.w3m}/bin/w3m";
  sxiv-bin = "${pkgs.sxiv}/bin/w3m";
  zathura-bin = "${pkgs.zathura}/bin/w3m";
  importcal-bin = "${pkgs.writeShellScriptBin "print_and_import_cal.sh" ''
    ${builtins.readFile ./print_and_import_cal.sh}
  ''}/bin/print_and_import_cal.sh";
in
{
  home.file.".config/mailcap" = {
    text = ''
      application/pdf; ${zathura-bin} '%s'; test=test -n "$DISPLAY"
      application/x-pdf; ${zathura-bin} '%s'; test=test -n "$DISPLAY"
      application/ics; ${importcal-bin} '%s'
      text/calendar; ${importcal-bin} '%s'
    '';
  };
}
