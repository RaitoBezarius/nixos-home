{
  colorscheme = ''
    # Evan Widloski - 2018-04-18
    # Neomutt Monokai Theme

#---------- Colors ----------
    set my_background = "color234"
    set my_gray = "color245"
    set my_magenta = "color198"
    set my_brightmagenta = "brightcolor198"
    set my_green = "color112"
    set my_brightgreen = "brightcolor112"
    set my_red = "color160"
    set my_darkgray = "color235"
    set my_tan = "color185"
    set my_blue = "color81"
    set my_lavender = "color141"

# index menu
    color index $my_gray $my_background ".*"
    color index_date $my_magenta $my_background
    color index_subject white $my_background "~R"
    color index_subject brightwhite $my_background "~U"
    color index_author $my_green $my_background "~R"
    color index_author $my_brightgreen $my_background "~U"

# message display
    color normal white $my_background
    color error $my_red $my_background
    color tilde $my_darkgray $my_background
    color message white $my_background
    color markers $my_red white
    color attachment white $my_background
    color bold brightwhite $my_background
    color underline brightcolor81 $my_background
    color quoted $my_tan $my_background
    color quoted1 $my_blue $my_background
    color quoted2 $my_green $my_background
    color quoted3 $my_lavender $my_background
    color hdrdefault $my_gray $my_background
    color header brightwhite $my_background "^(Subject)"

    color search $my_lavender $my_background
    color status $my_gray $my_darkgray
# header/footer menu
    color indicator $my_background $my_tan
# thread tree arrows
    color tree $my_tan $my_background

  '';
}
