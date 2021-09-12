{ ... }:
{
  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = [ "zathura.desktop" ];
      "image/jpeg" = [ "feh.desktop" ];
    };
  };
}
