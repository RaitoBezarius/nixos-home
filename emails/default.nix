{ osConfig, config, pkgs, lib, ... }:
let
  utils = (import ./utils.nix { inherit lib; });
  realName = utils.obfuscate "afhaL nayR";
  # returns password element and cache it in long term session.
  mkKachPass = target: pkgs.raito-dev.kachpass.mkKachPass {
    targetKeyring = target;
  };
  passStore = rec {
    generic = drv: key: "${drv}/bin/kachpass ${key}";
    process = generic (mkKachPass "@p");
    user = generic (mkKachPass "@u");
    defaultSession = generic (mkKachPass "@us");
    session = generic (mkKachPass "@s");
  };
  # the issue is that mailboxes is stricter now, so fake entries have to be injected using named-mailboxes.
  list-mailboxes = pkgs.writeScriptBin "list-mailboxes" ''
    find ${config.accounts.email.maildirBasePath}/$1 -type d -name cur | sort | sed -e 's:/cur/*$::' -e 's/ /\\ /g' | uniq | tr '\n' ' '
  '';
  list-empty-mailboxes = pkgs.writeScriptBin "list-empty-mailboxes" ''
    find ${config.accounts.email.maildirBasePath}/$1 -type d -exec bash -c 'd1=("$1"/cur/); d2=("$1"/*/); [[ ! -e "$d1" && -e "$d2" ]]' _ {} \; -printf "%p "
  '';
  autodiscoverMailboxes = path: "mailboxes `${list-mailboxes}/bin/list-mailboxes ${path}`";
  mkKurisuMailbox = { realName, address, userName ? address, mailboxPath, namedMailbox, passStorePath, notificationPrefix }: {
    inherit realName address userName;
    mbsync = {
      enable = true;
      create = "both";
    };
    msmtp.enable = true;
    neomutt = {
      enable = true;
      extraConfig = ''
        ${autodiscoverMailboxes mailboxPath}
        named-mailboxes ${namedMailbox} +Inbox
      '';
    };
    notmuch.enable = true;
    passwordCommand = passStore.defaultSession passStorePath;

    imapnotify = {
      enable = true;
      boxes = [ "Inbox" ];
      onNotify = "${pkgs.isync}/bin/mbsync ${mailboxPath}";
      onNotifyPost = ''
        ${pkgs.notmuch}/bin/notmuch new \
        && ${pkgs.libnotify}/bin/notify-send "${notificationPrefix}: New mail arrived."
      '';
    };

    imap = {
      host = "kurisu.lahfa.xyz";
      tls.enable = true;
    };
    smtp = {
      host = "kurisu.lahfa.xyz";
      port = 587;
      tls.enable = true;
      tls.useStartTls = true;
    };

    signature = {
      showSignature = "append";
      text = ''
        ${realName}
      '';
    };
  };
in
  with utils;
# This module requires runtime secrets to
# fetch the emails and monitor them.
lib.optionalAttrs osConfig.my.runtime-secrets {
  imports = [
    ./afew.nix
    ./mailcap.nix
    ./neomutt.nix
    ./mailto.nix
    ./imapfilter
  ];

  home.packages = [
    list-mailboxes
    list-empty-mailboxes
  ];

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    imapfilter.enable = true;
    notmuch = {
      enable = true;
      new = {
        tags = [ "unread" "new" ];
      };
    };
  };

  services.imapnotify.enable = true;

  accounts.email = {
    maildirBasePath = "mail";
    accounts = {
      ens-fr = {
        primary = true;
        inherit realName;
        address = obfuscate "rf.sne@afhal.nayr";
        signature = {
          showSignature = "append";
          text = ''
            ${realName}
          '';
        };

        mbsync = {
          enable = true;
          create = "both";
        };
        imapfilter = {
          enable = true;
          filterScriptFile = ../dotfiles/filters/ens.lua;
        };
        msmtp.enable = true;
        neomutt = {
          enable = true;
          extraConfig = ''
            ${autodiscoverMailboxes "ens-fr"}
            unmailboxes +Inbox
            named-mailboxes ENS-Inbox +Inbox

            folder-hook . "set sort=reverse-date ; set sort_aux=date"
            folder-hook Inbox/DG "set sort=threads ; set sort_aux = reverse-last-date-received"
            # Je ne suis plus DG.
            # reply-hook "~t dg@ens.fr" "my_hdr From: Ryan Lahfa — DG <dg@ens.fr> ; my_hdr cc: dg@ens.fr"
            # reply-hook "~t dg@ens.psl.eu" "my_hdr From: Ryan Lahfa — DG <dg@ens.fr> ; my_hdr cc: dg@ens.fr"
            # TODO: finir les alias hackENS
            reply-hook "~t hackens@clipper.ens.fr" "my_hdr From: Ryan Lahfa — responsable hackENS <hackens@ens.fr> ; my_hdr cc: hackens@ens.fr"
          '';
        };
        userName = "rlahfa";
        imap = {
          host = "clipper.ens.fr";
          tls.enable = true;
        };
        smtp = {
          host = "clipper.ens.fr";
          tls.enable = true;
          port = 465;
        };
        notmuch.enable = true;
        passwordCommand = passStore.defaultSession "ENS/SPI";
        imapnotify = {
          enable = true;
          boxes = [ "INBOX" ];
          onNotify = "${pkgs.isync}/bin/mbsync ens-fr";
          onNotifyPost = ''
              ${pkgs.notmuch}/bin/notmuch new \
              && ${pkgs.libnotify}/bin/notify-send "ENS: New mail arrived."
            '';
        };
      };
      masterancpp = {
        realName = "Raito Bezarius";
        address = "masterancpp@gmail.com";
        flavor = "gmail.com";
        mbsync = {
          enable = true;
          create = "both";
        };
        msmtp.enable = true;
        neomutt = {
          enable = true;
          extraConfig = ''
            unmailboxes +Inbox
            named-mailboxes GMail-Inbox +Inbox
          '';
        };
        passwordCommand = passStore.defaultSession "Private/Mail/Thorfinn/GMail";
      };
      mangaki = mkKurisuMailbox {
        realName = "${realName} — Mangaki";
        address = obfuscate "rf.ikagnam@nayr";

        mailboxPath = "mangaki";
        namedMailbox = "Mangaki-Inbox";
        passStorePath = obfuscate "rf.ikagnam@nayr/ikagnaM";
        notificationPrefix = "Mangaki";
      };
      nixos-paris = mkKurisuMailbox {
        realName = "${realName} — NixOS Paris";
        address = obfuscate "sirap.soxin@nayr";

        mailboxPath = "nixos-paris";
        namedMailbox = "NixOS-Paris-Inbox";
        passStorePath = obfuscate "sirap.soxin@nayr/SOxiN";
        notificationPrefix = "NixOS";
      };
      dgnum = mkKurisuMailbox {
        realName = "${realName} — Expert DGNum";
        address = obfuscate "ue.mungd@nayr";

        mailboxPath = "dgnum";
        namedMailbox = "DGNum-Inbox";
        passStorePath = obfuscate "ue.mungd@nayr/liaM/etavirP";
        notificationPrefix = "DGNum";
      };
      ryan-xyz = mkKurisuMailbox {
        inherit realName;

        address = obfuscate "zyx.afhal@nayr";

        mailboxPath = "ryan-xyz";
        namedMailbox = "Personal-Inbox";
        passStorePath = obfuscate "zyx.afhal@nayr/6V/liaM/etavirP";
        notificationPrefix = "Personal";
      };
    };
  };
}
