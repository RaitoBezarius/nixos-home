{ osConfig, ... }:
{
  services.picom = {
    enable = osConfig.my.display-server == "xorg";
    vSync = false;
  };
}
