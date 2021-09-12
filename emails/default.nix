{ config, pkgs, lib, ... }:
let
  mkVirtualBox = searchTerm: name: ''
    virtual-mailboxes "${name}" "notmuch://?query=${searchTerm}"
  '';
  virtualboxes = (import ./virtualboxes.nix).virtualboxes;
  colorscheme = (import ./colorscheme.nix).colorscheme;
  utils = (import ./utils.nix { inherit lib; });
  realName = utils.obfuscate "afhaL nayR";
  passStore = key: "${pkgs.pass}/bin/pass ${key}";
in
  with utils;
{
  imports = [
    # ./afew.nix
    ./mailcap.nix
    ./imapfilter
  ];

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    imapfilter.enable = true;
    neomutt = {
      enable = true;
      sidebar.enable = true;
      sidebar.shortPath = true;
      sidebar.format = "%D%* %n";
      vimKeys = true;
      sort = "reverse-date";
      extraConfig = ''
        bind index,pager K sidebar-prev       
        bind index,pager J sidebar-next       
        bind index,pager \CO sidebar-open       # Ctrl-Shift-O - Open Highlighted Mailbox
        bind index,pager B sidebar-toggle-visible

        set sidebar_width = 30
        set sidebar_delim_chars="/"             # Delete everything up to the last / character
        set sidebar_folder_indent               # Indent folders whose names we've shortened
        set sidebar_indent_string="  "          # Indent with two spaces
        set mail_check_stats=yes
        set sidebar_component_depth = 0
        set sidebar_sort_method = "path"
        set sidebar_new_mail_only = no
        set sidebar_non_empty_mailbox_only = no

        alternative_order text/plain text/html
        set mailcap_path = ~/.config/mailcap
        macro attach 'V' "<pipe-entry>iconv -c --to-code=UTF8 > ~/.cache/mutt/mail.html<enter><shell-escape>$BROWSER ~/.cache/mutt/mail.html<enter>"

        ${colorscheme}
      '';
    };
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
            mailboxes `find ${config.accounts.email.maildirBasePath}/ens-fr -type d -name cur | sort | sed -e 's:/cur/*$::' -e 's/ /\\ /g' | tr '\n' ' '`

            folder-hook . "set sort=reverse-date ; set sort_aux=date"
            folder-hook Inbox/DG "set sort=threads ; set sort_aux = reverse-last-date-received"
            reply-hook "~t dg@ens.fr" "my_hdr From: Ryan Lahfa — DG <dg@ens.fr> ; my_hdr cc: dg@ens.fr"
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
          mailboxes `find ${config.accounts.email.maildirBasePath}/ryan-xyz -type d -name cur | sort | sed -e 's:/cur/*$::' -e 's/ /\\ /g' | tr '\n' ' '`
          '';
        };
        notmuch.enable = true;
        passwordCommand = passStore "Private/Mail/V6/ryan@lahfa.xyz";
      };
    };
  };
}

