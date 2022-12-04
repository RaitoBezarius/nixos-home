{ config, pkgs, ... }:
let
smart-pinentry = pkgs.writeScriptBin "pinentry" ''
        #!${pkgs.runtimeShell}
        # choose pinentry depending on PINENTRY_USER_DATA
        # requires pinentry-curses and pinentry-gtk2
        # this *only works* with gpg 2
        # see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=802020
        
        case $PINENTRY_USER_DATA in
        gtk)
          exec ${pkgs.pinentry-qt}/bin/pinentry-qt "$@"
          ;;
        none)
          exit 1 # do not ask for passphrase
          ;;
        *)
          exec ${pkgs.pinentry.curses}/bin/pinentry "$@"
        esac
        '';
  in
{
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentryFlavor = null;
    extraConfig = ''
      pinentry-program ${smart-pinentry}/bin/pinentry
    '';
  };
  # Browser Pass
  programs.browserpass = {
    enable = true;
    browsers = [ "chromium" ];
  };
}
