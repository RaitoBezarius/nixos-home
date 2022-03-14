{ config, pkgs, ... }:
{
  # age.secrets.rzDroneToken.file = ./secrets/rzDroneToken.age;
  home.packages = [
    (pkgs.writeScriptBin "rz-drone" ''
      #!${pkgs.stdenv.shell}
      export DRONE_SERVER=https://drone.rz.ens.wtf
      ${pkgs.drone-cli}/bin/drone "$@"
    '')
    (pkgs.writeScriptBin "pnotify" ''
      #!${pkgs.stdenv.shell}
      ${pkgs.curl}/bin/curl -X POST "$GOTIFY_URL/message?token=$GOTIFY_TOKEN" -F"title=$1" -F"message=$2"
    '')
    (pkgs.writeScriptBin "get_ssl_sha256" (
      let
        openssl = "${pkgs.openssl}/bin/openssl";
      in
    ''
      #!${pkgs.stdenv.shell}
      echo | ${openssl} s_client -connect $1:$2 |& ${openssl} x509 -fingerprint -noout -sha256 | cut -d'=' -f2 | sed 's/://g' | tr '[:upper:]' '[:lower:]'
    ''))
  ];
}
