{ config, pkgs, lib, ... }:
let
  mkVirtualBox = searchTerm: name: ''
    virtual-mailboxes "${name}" "notmuch://?query=${searchTerm}"
  '';
  virtualboxes = (import ./virtualboxes.nix).virtualboxes;
  colorscheme = (import ./colorscheme.nix).colorscheme;
in
{
  programs.neomutt = {
    enable = true;
    sidebar.width = 40;
    sidebar.enable = true;
    sidebar.shortPath = true;
    sidebar.format = "%D%> %?N?%N/?%S";
    vimKeys = true;
    sort = "reverse-date";
    extraConfig = ''
      bind index,pager K sidebar-prev       
      bind index,pager J sidebar-next       
      bind index,pager \CO sidebar-open       # Ctrl-Shift-O - Open Highlighted Mailbox
      bind index,pager B sidebar-toggle-visible

      set sidebar_delim_chars="/"             # Delete everything up to the last / character
      set sidebar_folder_indent               # Indent folders whose names we've shortened
      set sidebar_indent_string="  "          # Indent with two spaces
      set mail_check_stats=yes
      set sidebar_component_depth="1"
      set sidebar_sort_method = "path"
      set sidebar_new_mail_only = no
      set sidebar_non_empty_mailbox_only = no

      alternative_order text/plain text/html
      set mailcap_path = ~/.config/mailcap
      macro pager \cb "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
      macro index,pager O "<shell-escape>mbsync -a<enter>" "run mbsync to sync all emails"
      macro attach 'V' "<pipe-entry>iconv -c --to-code=UTF8 > ~/.cache/mutt/mail.html<enter><shell-escape>$BROWSER ~/.cache/mutt/mail.html<enter>"

      ${colorscheme}
    '';
  };
}
