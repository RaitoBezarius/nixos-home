{ config, pkgs, lib, ... }:
let
  mkVirtualBox = searchTerm: name: ''
    virtual-mailboxes "${name}" "notmuch://?query=${searchTerm}"
  '';
  virtualboxes = (import ./virtualboxes.nix).virtualboxes;
  colorscheme = (import ./colorscheme.nix).colorscheme;
  useASAN = true;
in
{
  programs.neomutt = {
    enable = true;
    package = pkgs.enableDebugging (pkgs.neomutt.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [ "--with-kyotocabinet=${pkgs.kyotocabinet}" "--zstd" "--mixmaster" ] ++ lib.optional useASAN "--asan";
      buildInputs = old.buildInputs ++ [ pkgs.zstd ];
#      src = pkgs.fetchFromGitHub {
#        owner = "neomutt";
#        repo = "neomutt";
#        rev = "fd5745f56fd4c3a80fcf5dec42a0db2f1573b4c5";
#        sha256 = "sha256-vAS9omz3AGAMdsnSgsqXTGTQaY1aev4MEVvsC+W6j/k=";
#      };
      patches = [];
    }));
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
      bind pager ,g group-reply

      set sidebar_delim_chars="/"             # Delete everything up to the last / character
      set sidebar_folder_indent               # Indent folders whose names we've shortened
      set sidebar_indent_string="  "          # Indent with two spaces
      set mail_check_stats=yes
      set sidebar_component_depth="1"
      set sidebar_sort_method = "path"
      set sidebar_new_mail_only = no
      set sidebar_non_empty_mailbox_only = no

      set header_cache_backend='lmdb'
      set header_cache='~/mail/hcache'
      set header_cache_compress_method = "zstd"
      set header_cache_compress_level = 10

      alternative_order text/plain text/html
      set mailcap_path = ~/.config/mailcap

      set mime_forward = no
      set forward_attachments = yes
      macro pager \cb "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
      macro index,pager O "<shell-escape>mbsync -a<enter>" "run mbsync to sync all emails"
      macro attach 'V' "<pipe-entry>iconv -c --to-code=UTF8 > ~/.cache/mutt/mail.html<enter><shell-escape>$BROWSER ~/.cache/mutt/mail.html<enter>"

      auto_view text/html image/*

      ${colorscheme}
    '';
  };
}
