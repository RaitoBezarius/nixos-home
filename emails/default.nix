{ config, pkgs, lib, ... }:
let
  mkVirtualBox = searchTerm: name: ''
    virtual-mailboxes "${name}" "notmuch://?query=${searchTerm}"
  '';
  virtualboxes = (import ./virtualboxes.nix).virtualboxes;
  colorscheme = (import ./colorscheme.nix).colorscheme;
  utils = (import ./utils.nix { inherit lib; });
in
  with utils;
{
  imports = [
    ./afew.nix
  ];

  services = {
    imapnotify.enable = false;
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    neomutt = {
      enable = true;
      sidebar.enable = true;
      vimKeys = true;
      sort = "reverse-date";
      extraConfig = ''
        bind index,pager \CP sidebar-prev       # Ctrl-Shift-P - Previous Mailbox
        bind index,pager \CN sidebar-next       # Ctrl-Shift-N - Next Mailbox
        bind index,pager \CO sidebar-open       # Ctrl-Shift-O - Open Highlighted Mailbox

        set sidebar_short_path                  # Shorten mailbox names
        set sidebar_delim_chars="/"             # Delete everything up to the last / character
        set sidebar_folder_indent               # Indent folders whose names we've shortened
        set sidebar_indent_string="  "          # Indent with two spaces

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

  accounts.email = {
    maildirBasePath = "mail";
    accounts = {
      ryan-xyz = {
        primary = true;

        realName = obfuscate "afhaL nayR";
        signature = {
          showSignature = "append";
          text = ''
            ${obfuscate "afhaL nayR"}
          '';
        };

        address = obfuscate "zyx.afhal@nayr";
        aliases = [ (obfuscate "zyx.afhal@nimda") ];

        userName = obfuscate "zyx.afhal@nayr";
        imap = {
          host = "mail.lahfa.xyz";
          tls.enable = true;
        };
        smtp = {
          host = "mail.lahfa.xyz";
          tls.enable = true;
        };

        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotifyPost = {
            mail = ''
              ${pkgs.notmuch}/bin/notmuch new \
              && ${pkgs.libnotify}/bin/notify-send "New mail arrived."
            '';
          };
        };
        mbsync = {
          enable = true;
          create = "both";
        };
        msmtp.enable = true;
        neomutt = {
          enable = true;
          extraConfig = ''
            ${mkVirtualBox "tag:inbox" "BAL"}
            ${virtualboxes}
            unmailboxes "/home/raito/mail/ryan-xyz/Inbox"
            unvirtual-mailboxes "My INBOX"
          '';
        };
        notmuch.enable = true;
        passwordCommand = "pass Private/Mail/lahfa.xyz";
      };
    };
  };
}

