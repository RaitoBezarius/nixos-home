{ ... }:
{
  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = [ "zathura.desktop" ];
      "image/jpeg" = [ "feh.desktop" ];
      "x-scheme-handler/mailto" = [ "mutt.desktop" ];
    };
    defaultApplications = {
      "x-scheme-handler/http" = "chromium.desktop";
      "x-scheme-handler/https" = "chromium.desktop";
    };
  };
}
