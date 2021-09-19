{ pkgs, config, ... }:
let
  passStore = key: [ "command" "${pkgs.pass}/bin/pass" key ];
in
{
  imports = [
    ./modules/vdirsyncer.nix
  ];

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
    };
  };
}
