{ pkgs, ... }:
{
  gtk = {
    enable = true;
    gtk3 = {
      bookmarks = [
        "file:///home/raito/dev"
        "file:///home/raito/pics"
        "file:///home/raito/pics/screens"
        "file:///home/raito/docs"
        "file:///home/raito/docs/identity"
      ];
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
    theme = {
      name = "Paper";
      package = pkgs.paper-gtk-theme;
    };
  };
}
