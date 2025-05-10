{ lib, pkgs, config, osConfig, ... }:
let
  cfg = config.wayland.windowManager;
  workspaceNumberToFrenchSymbol = {
    "1" = "ampersand";
    "2" = "eacute";
    "3" = "quotedbl";
    "4" = "apostrophe";
    "5" = "parenleft";
    "6" = "minus";
    "7" = "egrave";
    "8" = "underscore";
    "9" = "ccedilla";
    "10" = "agrave";
  };
  workspaces = lib.range 1 10;
  mkWorkspaceSym = symFn: valueFn: mod:
    lib.listToAttrs (map (index:
    let sym = workspaceNumberToFrenchSymbol.${toString index};
    in { name = (symFn mod sym index); value = valueFn index; }) workspaces);
  mkMoveToWorkspace = mkWorkspaceSym
    (mod: sym: _: "${mod}+${sym}")
    (index: "workspace ${toString index}");
  mkMoveContainerToWorkspace = mkWorkspaceSym
    # Nix has no % operator ???
    (mod: sym: index: if index >= 6 then (if index == 10 then "${mod}+Shift+0" else "${mod}+Shift+${toString index}")
    else "${mod}+Shift+${sym}")
    (index: "move container to workspace number ${toString index}");
in
{
  #home.file.".config/sway/config".source =
  #  config.lib.file.mkOutOfStoreSymlink ./dotfiles/sway;
  home.file.".config/waybar/config".source = ./dotfiles/waybar/config;
  home.file.".config/waybar/style.css".source = ./dotfiles/waybar/style.css;

  dconf.enable = true;

  home.packages = with pkgs; [
    swaylock
    grim
    slurp
    swappy
    swayidle
    waypipe
    # wf-recorder
    xdg-utils
    brillo
    wl-clipboard
    wdisplays
    kanshi
  ];

  programs.zsh.loginExtra = lib.mkIf (osConfig.my.display-server == "wayland") ''
    if [[ -z $DISPLAY ]] && [[ $(tty) = "/dev/tty1" ]]; then
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
      exec sway
    fi
  '';

  # Mako systemd service.
  wayland.windowManager.sway = lib.mkIf (osConfig.my.display-server == "wayland") {
    enable = true;
    systemd.enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    xwayland = true;
    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=0
      export QT_SCALE_FACTOR=1
      export GDK_SCALE=1
      export GDK_DPI_SCALE=1
      export MOZ_ENABLE_WAYLAND=1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "${lib.getExe pkgs.wofi} --show run | ${pkgs.findutils}/bin/xargs swaymsg exec --";

      fonts = {
        names = [ "pango:Fira Mono for Powerline" "FontAwesome 10" ];
        size = 9.0;
        style = "Normal";
      };

      startup = [
        # Idle configuration
      #  { command = ''swayidle -w \
      #    timeout 300 'swaylock -f -c 000000' \
      #    timeout 600 'swaymsg "output * dpms off"' \
      #      resume 'swaymsg "output * dpms on"' \
      #    before-sleep 'swaylock -f -c 000000'
      #    '';
      #  }
      ];

      input = {
        "type:keyboard" = {
          xkb_layout = "fr";
          xkb_model = "pc105";
          xkb_variant = "oss";
          xkb_options = "nbsp:none";
          repeat_delay = "250";
          repeat_rate = "60";
        };
      };

      keybindings = lib.mkOptionDefault ({
        "Shift+Print" = "exec grim - | wl-copy";
        "Shift+Alt+Print" = ''exec grim -g "$(slurp)" - | wl-copy'';
        "Print" = "exec --no-startup-id flameshot gui";
        "${modifier}+l" = "exec swaylock -f -c 000000";
        "${modifier}+p" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";
        # TODO: quick edit /etc/nixos as root
        # TODO: quick commit to my repository, the changes.
        "${modifier}+Shift+a" = "gksudo nrs --no-build-nix";
        "${modifier}+m" = "move workspace to output left";
        "${modifier}+r" = "mode resize";
        "${modifier}+s" = "scratchpad show";
        "${modifier}+Shift+s" = "move scratchpad";
      } // (mkMoveToWorkspace modifier) // (mkMoveContainerToWorkspace modifier));

      modes.resize = {
        Left = "resize shrink width 10px";
        Down = "resize grow height 10px";
        Up = "resize shrink height 10px";
        Right = "resize grow width 10px";
        Return = "mode default";
        Escape = "mode default";
      };

      bars = [
        {
          position = "bottom";
          statusCommand = "${lib.getExe pkgs.i3status-rust} ~/.config/i3status-rs/config-bottom.toml";
          fonts = cfg.sway.config.fonts // { size = 11.0; };
        }
        {
          position = "top";
          statusCommand = "${lib.getExe pkgs.i3status-rust} ~/.config/i3status-rs/config-top.toml";
          fonts = cfg.sway.config.fonts // { size = 11.0; };
        }
      ];
    };
  };

  services.mako = lib.mkIf (osConfig.my.display-server == "wayland") {
    enable = true;
    criteria."mode=dnd".invisible = 1;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

  # TODO: branch on the type of machine
  services.kanshi = lib.mkIf (osConfig.my.display-server == "wayland") {
    enable = true;
    profiles = {
      paris-dock = {
        outputs = [
          {
            criteria = "ViewSonic Corporation XG270 VXR200700013";
            mode = "1920x1080@60.000Hz";
            position = "0,0";
            scale = 1.0;
            status = "enable";
          }
          {
            criteria = "ViewSonic Corporation VG2765 Series UXS183300233";
            mode = "2560x1440@59.951Hz";
            position = "1920,0";
            scale = 1.0;
            transform = "90";
            status = "enable";
          }
        ];
      };
      undocked = {
        outputs = [{
          criteria = "eDP-1";
          mode = "3000x2000@59.999";
          scale = 2.0;
          status = "enable";
        }];
      };
    };
  };
}
