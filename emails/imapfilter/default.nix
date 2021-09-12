{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.imapfilter;
  imapfilterAccounts = filter (a: a.imapfilter.enable) (attrValues config.accounts.email.accounts);
  safeName = acc: replaceStrings ["-"] ["_"] acc.name;
  mkIMAPAccount = acc: ''
  ${safeName acc}_account = IMAP {
          server = "${acc.imap.host}",
          username = "${acc.userName}",
          ssl = "auto",
          password = exec_password_command("${toString acc.passwordCommand}")
  }
  '';
  mkRequireAccountModule = acc: "local ${safeName acc}_mod = dofile(\"${acc.imapfilter.filterScriptFile}\")";
  mkInitialFilter = acc: "${safeName acc}_mod.filter(${safeName acc}_account)";
  mkEventLoopStep = acc: "${safeName acc}_mod.event_loop_step(${safeName acc}_account)";
  mkDaemonPerAccount = acc: ''
    ${cfg.preludeLua}
    ${mkIMAPAccount acc}
    ${mkRequireAccountModule acc}
    ${mkInitialFilter acc}
    while true do
      ${mkEventLoopStep acc}
    end
  '';
  mkDaemonUnit = acc: 
  let
    cfgFile = pkgs.writeText "${acc.name}_daemon.lua" (mkDaemonPerAccount acc);
  in
  {
    Unit = {
      Description = "Filter remotely your emails on account ${acc.name} over IMAP";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];

      StartLimitIntervalSec = 3;
      StartLimitBurst = 3;
    };

    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = "${pkgs.imapfilter}/bin/imapfilter -c ${cfgFile}";
      Restart = "on-failure";
      Type = "exec";
      RestartSec = 30;
    };
  };
in
{
  options = {
    programs.imapfilter = {
      enable = mkEnableOption "remote filtering over IMAP with IMAP IDLE";
      preludeLua = mkOption {
        type = types.str;
        description = "Prelude for the Lua entrypoint configuration file";
        default = ''
          function exec_password_command(cmd)
                  status, output = pipe_from(cmd)
                  return output:gsub("%s+", "")
          end
        '';
        example = "local utils = require \"utils\"";
      };
      extraPackages = mkOption {
        type = types.listOf types.package;
        description = "Extra packages to make available to imapfilter daemon (e.g. pass)";
        default = [];
        example = [ pkgs.pass ];
      };
    };

    accounts.email.accounts = mkOption {
      type = with types; attrsOf (submodule (import ./accounts.nix));
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.imapfilter ];
    systemd.user.services = mapAttrs' (n: v: nameValuePair "imapfilter-${n}" (mkDaemonUnit v))
      (listToAttrs (map (acc: nameValuePair acc.name acc) imapfilterAccounts));
  };
}
