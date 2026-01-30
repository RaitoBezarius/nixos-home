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
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull; # for git send-email

    ignores = [
      ".direnv"
    ];

    settings = {
      user = {
        email = emailUtils.obfuscate "moc.liamg@ppcnaretsam";
        name = emailUtils.obfuscate "suirazeB otiaR";

        signingkey = lib.mkIf (builtins.hasAttr osConfig.networking.hostName signingKeys) (signingKeys.${osConfig.networking.hostName});
      };

      fetch.writeCommitGraph = true;
      core.fsmonitor = true;
      ghq = {
        root = "~/dev";
      };
      push.autoSetupRemote = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.commit.signOff = true;
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
