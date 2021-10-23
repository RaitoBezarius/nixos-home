{ config, pkgs, lib, ... }:
let
  utils = (import ./utils.nix { inherit lib; });
  realName = utils.obfuscate "afhaL nayR";
  # returns password element and cache it in long term session.
  passStore = key: "${pkgs.raito.kachpass}/bin/kachpass ${key}";
  # the issue is that mailboxes is stricter now, so fake entries have to be injected using named-mailboxes.
  list-mailboxes = pkgs.writeScriptBin "list-mailboxes" ''
    find ${config.accounts.email.maildirBasePath}/$1 -type d -name cur | sort | sed -e 's:/cur/*$::' -e 's/ /\\ /g' | uniq | tr '\n' ' '
  '';
  list-empty-mailboxes = pkgs.writeScriptBin "list-empty-mailboxes" ''
    find ${config.accounts.email.maildirBasePath}/$1 -type d -exec bash -c 'd1=("$1"/cur/); d2=("$1"/*/); [[ ! -e "$d1" && -e "$d2" ]]' _ {} \; -printf "%p "
  '';
  autodiscoverMailboxes = path: "mailboxes `${list-mailboxes}/bin/list-mailboxes ${path}`";
in
  with utils;
{
  imports = [
    # ./afew.nix
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
            reply-hook "~t dg@ens.fr" "my_hdr From: Ryan Lahfa — DG <dg@ens.fr> ; my_hdr cc: dg@ens.fr"
            reply-hook "~t dg@ens.psl.eu" "my_hdr From: Ryan Lahfa — DG <dg@ens.fr> ; my_hdr cc: dg@ens.fr"
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
        passwordCommand = passStore "ENS/SPI";
        imapnotify = {
          enable = true;
          boxes = [ "INBOX" "INBOX/DG" ];
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
        passwordCommand = passStore "Private/Mail/Thorfinn/GMail";
      };
      ryan-xyz = {
        inherit realName;
        signature = {
          showSignature = "append";
          text = ''
            ${realName}
          '';
        };

        address = obfuscate "zyx.afhal@nayr";
        aliases = [ (obfuscate "zyx.afhal@nimda") ];

        userName = obfuscate "zyx.afhal@nayr";
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

        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotify = "${pkgs.isync}/bin/mbsync ryan-xyz";
          onNotifyPost = ''
            ${pkgs.notmuch}/bin/notmuch new \
            && ${pkgs.libnotify}/bin/notify-send "Personal: New mail arrived."
          '';
        };
        mbsync = {
          enable = true;
          create = "both";
        };
        msmtp.enable = true;
        neomutt = {
          enable = true;
          extraConfig = ''
            ${autodiscoverMailboxes "ryan-xyz"}
            unmailboxes +Inbox
            named-mailboxes Personal-Inbox +Inbox
          '';
        };
        notmuch.enable = true;
        passwordCommand = passStore "Private/Mail/V6/ryan@lahfa.xyz";
      };
    };
  };
}

