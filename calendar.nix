{ pkgs, config, ... }:
let
  passStore = key: [ "command" "${pkgs.raito-dev.kachpass}/bin/kachpass" key ];
in
{
  imports = [
    ./modules/vdirsyncer.nix
  ];

  programs.zsh.shellAliases."vsync" = "vdirsyncer -c ${config.services.vdirsyncer.configFile}";

  services.vdirsyncer = {
    enable = true;

    settings = {
      general."status_path" = "${config.home.homeDirectory}/.config/vdirsyncer";
      "pair ens_kumo" = {
        a = "ens";
        b = "kumo";
        collections = [ [ "dg" "dg_shared_by_dg@ens.fr" "dg@ens.fr" ] ];
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
      "storage local" = {
        type = "filesystem";
        path = "${config.home.homeDirectory}/.calendar/";
        fileext = ".ics";
      };
    };
  };
}
