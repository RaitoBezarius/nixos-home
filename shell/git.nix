{ osConfig, pkgs, lib, ... }:
let
  emailUtils = import ../emails/utils.nix { inherit lib; };
  signingKeys = {
    "Thorkell" = "1944DAD8026ABF75!";
  };
in
{
  # Git
  home.packages = [ pkgs.ghq ];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull; # for git send-email
    userEmail = emailUtils.obfuscate "moc.liamg@ppcnaretsam";
    userName = emailUtils.obfuscate "suirazeB otiaR";

    delta.enable = true;
    ignores = [
      ".direnv"
    ];

    extraConfig = {
      user.signingkey = lib.mkIf (builtins.hasAttr osConfig.networking.hostName signingKeys) (signingKeys.${osConfig.networking.hostName});
      ghq = {
        root = "~/dev";
      };
      push.autoSetupRemote = true;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      version = 1;
      git_protocol = "ssh";
      extensions = [ pkgs.gh-dash pkgs.gh-eco ];
    };
  };
}
