{ pkgs, ... }:
let
  defaultFp = {
    eDP1 =
      "00ffffffffffff000daec3140000000026190104951f1178027e45935553942823505400000001010101010101010101010101010101da1d56e250002030442d470035ad10000018000000fe004e3134304247412d4541330a20000000fe00434d4e0a202020202020202020000000fe004e3134304247412d4541330a200053";
  };
in {
  programs.autorandr = {
    enable = true;

    hooks.postswitch = {
      "inform-user" = ''
        ${pkgs.libnotify}/bin/notify-send -i display "Display profile" "$AUTORANDR_CURRENT_PROFILE"'';
      "restore-backgrounds" = "${pkgs.nitrogen}/bin/nitrogen --restore";
      "fixup-keyboard-speed" = "${pkgs.xorg.xset}/bin/xset r rate 300 50";
    };

    profiles = {
      mobile = {
        fingerprint = { inherit (defaultFp) eDP1; };

        config = {
          eDP1 = {
            enable = true;
            position = "0x0";
            mode = "1366x768";
            primary = true;
          };
        };
      };

      dell-docked = {
        fingerprint = {
          inherit (defaultFp) eDP1;
          # Dell UltraSharp.
          DP1 =
            "00ffffffffffff0010ace541574546432f1e0104a5351e783eee95a3544c99260f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00465854563232330a2020202020000000fc0044454c4c20553234323148450a000000fd00384c1e5a11010a202020202020019b02031cf14f90050403020716010611121513141f23097f0783010000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000000000000000017";
        };

        config = {
          eDP1 = {
            enable = true;
            position = "1920x0";
            mode = "1366x768";
            crtc = "1";
          };
          DP1 = {
            crtc = "0";
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
