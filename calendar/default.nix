{ lib, osConfig, pkgs, config, ... }:
let
  kachpass = pkgs.raito-dev.kachpass.mkKachPass {
    targetKeyring = "@us";
  };
  passStore = key: [ "command" "${kachpass}/bin/kachpass" key ];
in
# This module requires runtime secrets
# to interact with the different calendars.
lib.optionalAttrs osConfig.my.runtime-secrets {
  programs.zsh.shellAliases."vsync" = "vdirsyncer -c ${config.services.vdirsyncer.configFile}";

  services.vdirsyncer = {
    enable = false;

    settings = {
      general."status_path" = "${config.home.homeDirectory}/.config/vdirsyncer";
      "pair ens_kumo" = {
        a = "ens";
        b = "kumo";
        collections = [ [ "dg" "dg_shared_by_dg@ens.fr" "dg@ens.fr" ] ];
        conflict_resolution = "a wins";
        metadata = [ "color" "displayname" ];
      };
      "pair klubrz_kumo" = {
        a = "klubrz";
        b = "kumo";
        collections = [ "from a" ];
        conflict_resolution = "a wins";
        metadata = [ "color" "displayname" ];
      };
      "pair local_kumo" = {
        a = "local";
        b = "kumo";
        collections = [ "from a" "from b" ];
        conflict_resolution = "b wins";
        metadata = [ "color" "displayname" ];
      };
      "pair local_klubrz" = {
        a = "local";
        b = "klubrz";
        collections = [ "from b" ];
        conflict_resolution = "b wins";
        metadata = [ "color" "displayname" ];
      };
      "storage ens" = {
        type = "caldav";
        url = "https://cloud.eleves.ens.fr/remote.php/dav";
        username = "rlahfa";
        "password.fetch" = passStore "ENS/SPI";
      };
      "storage kumo" = {
        type = "caldav";
        url = "https://kumo.lahfa.xyz/remote.php/dav";
        username = "raito";
        "password.fetch" = passStore "Private/nextCloud/raito/vdirsyncer";
      };
      "storage klubrz" = {
        type = "caldav";
        url = "https://nuage.beta.rz.ens.wtf/remote.php/dav";
        username = "Keycloak-920b8639-e406-4f63-930d-efe44c3f79dd";
        "password.fetch" = passStore "ENS/Reseau/Nextcloud/raito/vdirsyncer";
      };
      "storage local" = {
        type = "filesystem";
        path = "${config.home.homeDirectory}/.calendar/";
        fileext = ".ics";
      };
    };
  };
}
