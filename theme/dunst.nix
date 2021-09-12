{ pkgs, ... }:
{
   services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        font = "Fira Mono for Powerline 13";
        sort = "yes";
        indicate_hidden = "yes";
        word_wrap = "yes";
        stack_duplicates = "yes";
        hide_duplicates_count = "yes";
        idle_threshold = "120";
        line_height = "0";
        max_icon_size = "64";
        markup = "full";
        format = "%s %p\\n%b";
        dmenu = "${pkgs.rofi}/bin/rofi";
        browser = "$BROWSER";
        geometry = "500x0-15+25";
        padding = "8";
        horizontal_padding = "10";
        frame_width = "0";
        frame_color = "#282a36";
        separator_color = "frame";
        transparency = "15";
        shrink = "no";
      };
      urgency_low = {
        background = "#282a36";
        foreground = "#6272a4";
        timeout = "10";
      };
      urgency_normal = {
        background = "#282a36";
        foreground = "#bd93f9";
        timeout = "20";
      };
      urgency_critical = {
        background = "#ff5555";
        foreground = "#f8f8f2";
        timeout = "0";
      };

    };
  };

  programs.noti.enable = true;
}
