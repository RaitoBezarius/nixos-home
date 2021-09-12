{ config, ... }:
{
  age.secrets.gotifyToken.file = ./secrets/gotifyToken.age;
  home.sessionVariables = {
    GOTIFY_TOKEN = "$(cat ${config.age.secrets.gotifyToken.file})";
    GOTIFY_URL = "https://notifications.lahfa.xyz";
  };
}
