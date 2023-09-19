{ lib, osConfig, pkgs, ... }:
let
  kachpass = pkgs.raito-dev.kachpass.mkKachPass {
    targetKeyring = "@us";
  };
in
lib.optionalAttrs osConfig.my.runtime-secrets {
  services.taskwarrior-caldav-sync = {
    "TODO" = {
      caldav.url = "https://kumo.lahfa.xyz/remote.php/dav";
      caldav.user = "raito";
      caldav.passwordManagerCommand = "${kachpass}/bin/kachpass";
      caldav.passwordManagerEntry = "Private/nextCloud/twsync";
      taskwarrior.tags = [ "sync-caldav" ];
      resolutionStrategy = "MostRecentRS";
    };
  };
}
