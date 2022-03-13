{ pkgs, ... }:
{
  services.picom = {
    enable = true;
    vSync = false;
  };
}
