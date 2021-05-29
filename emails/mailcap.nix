{ config, pkgs, lib, ... }:
let
  w3m-bin = "${pkgs.w3m}/bin/w3m";
  sxiv-bin = "${pkgs.sxiv}/bin/w3m";
  zathura-bin = "${pkgs.zathura}/bin/w3m";
in
{
  home.file.".config/mailcap" = {
    text = ''
      application/pdf; ${zathura-bin} '%s'; test=test -n "$DISPLAY"
      application/x-pdf; ${zathura-bin} '%s'; test=test -n "$DISPLAY"
    '';
  };
}
