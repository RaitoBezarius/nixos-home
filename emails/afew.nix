{ pkgs, lib, ... }:
with builtins;
let
  privateFilters = (import ./filters/private.nix { inherit lib; }).filters;
  filterLib = import ./filters/lib.nix { inherit lib; };
  callPackage = lib.callPackageWith filterLib;
  packagedFilters = map (p: callPackage p {}) [
    ./filters/sysadmin.nix
    ./filters/maths.nix
    ./filters/misc.nix
    ./filters/scop.nix
    ./filters/personal.nix
    ./filters/dev.nix
    ./filters/spammy.nix
    ./filters/videogames.nix
  ] ++ privateFilters;
  extraFilters = [
    (filterLib.mkSpamLike [
      "kanboard"
      "orangebank"
      "ing"
      "twitter"
      "rocketchat"
      "amazon"
      "igraal"
      "ecommerce"
      "videogames"
      "freelance"
      "spammy"
    ])
  ];
  finalFilters = packagedFilters;
  filters = (map (filterLib.mkFilter) (concatLists finalFilters)) ++ extraFilters;
in
  {
    programs.afew = {
      enable = true;
      extraConfig = ''
          [SpamFilter]
          # [DKIMValidityFilter]
          [DMARCReportInspectionFilter]
          [KillThreadsFilter]
          [ListMailsFilter]
          [ArchiveSentMailsFilter]
          sent_tag = sent
          ${filterLib.mkFilters filters}
          [InboxFilter]
      '';
    };
  }
