{ config, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program = "${pkgs.pinentry_qt5}/bin/pinentry-qt";
  '';

  # Browser Pass
  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };
}
