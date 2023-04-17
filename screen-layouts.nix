{ osConfig, lib, pkgs, ... }:
let
  defaultFp = {
    eDP-1 =
      "00ffffffffffff000daec3140000000026190104951f1178027e45935553942823505400000001010101010101010101010101010101da1d56e250002030442d470035ad10000018000000fe004e3134304247412d4541330a20000000fe00434d4e0a202020202020202020000000fe004e3134304247412d4541330a200053";
  };
in {
  programs.autorandr = lib.mkIf (osConfig.my.display-server == "xorg") {
    enable = true;

    hooks.postswitch = {
      "inform-user" = ''
        ${pkgs.libnotify}/bin/notify-send -i display "Display profile" "$AUTORANDR_CURRENT_PROFILE"'';
      "restore-backgrounds" = "${pkgs.nitrogen}/bin/nitrogen --restore";
      "fixup-keyboard-speed" = "${pkgs.xorg.xset}/bin/xset r rate 300 50";
    };

    profiles = {
      mobile = {
        fingerprint = { inherit (defaultFp) eDP-1; };

        config = {
          eDP-1 = {
            enable = true;
            position = "0x0";
            mode = "1366x768";
            primary = true;
          };
        };
      };

      tb-docked = {
        fingerprint = {
          inherit (defaultFp) eDP-1;
          DP-1-1 = "00ffffffffffff005a6338f601010101071e0103803c22782e4395aa544e9e260f5054bfef80d1c0d1e8b300950090408180814081c0023a801871382d40582c450056502100001e000000ff005658523230303730303031330a000000fd0030f00fff3c000a202020202020000000fc0058473237300a20202020202020018e020347f151010304050710121314161f20212260613f23097f078301000067030c002000187867d85dc401788801681a0000010130f0e6e305e000e40f00c000e60605015353008bdc806e703850401720980c56502100001afe7e8088703812401820350056502100001e000000000000000000000000000000000000000009";
          DP-1-3 = "00ffffffffffff005a63341201010101211c0104b53c22783f0c95ab554ca0240d5054bfef80e1c0d140d100d1c0b3009500818081c0565e00a0a0a029503020350055502100001a000000ff005558533138333330303233330a000000fd00324b18781904110140ff3bff3c000000fc0056473237363520536572696573019c020322f1559005040302070608090e0f1f1413121115161d1e0123097f0783010000023a801871382d40582c450055502100001e011d8018711c1620582c250055502100009e011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e9600555021000018023a80d072382d40102c458055502100001e00000062";
        };

        config = {
          eDP-1 = {
            enable = false;
            position = "1440x0";
            mode = "1366x768";
          };

          DP-1-1 = {
            enable = true;
            position = "0x0";
            mode = "1920x1080";
            primary = true;
          };

          DP-1-3 = {
            enable = true;
            position = "1920x0";
            mode = "2560x1440";
            rotate = "left";
          };
        };
      };

      dell-docked = {
        fingerprint = {
          inherit (defaultFp) eDP-1;
          # Dell UltraSharp.
          DP1 =
            "00ffffffffffff0010ace541574546432f1e0104a5351e783eee95a3544c99260f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00465854563232330a2020202020000000fc0044454c4c20553234323148450a000000fd00384c1e5a11010a202020202020019b02031cf14f90050403020716010611121513141f23097f0783010000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000000000000000017";
        };

        config = {
          eDP-1 = {
            enable = true;
            position = "1920x0";
            mode = "1366x768";
            crtc = 1;
          };
          DP1 = {
            crtc = 0;
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
        };
      };
    };
  };
}
