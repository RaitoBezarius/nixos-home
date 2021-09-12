{ pkgs, lib, ... }:
let
  emailUtils = import ./emails/utils.nix { inherit lib; };
in
{
  # Git
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull; # for git send-email
    userEmail = emailUtils.obfuscate "moc.liamg@ppcnaretsam";
    userName = emailUtils.obfuscate "suirazeB otiaR";
  };
}
