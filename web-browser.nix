{ ... }: {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform-hint=wayland"
      "--load-media-router-component-extension=1"
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "ldlghkoiihaelfnggonhjnfiabmaficg"; } # Alt+Q switcher
      { id = "enjjhajnmggdgofagbokhmifgnaophmh"; } # Resolution Zoom for HiDPI
      { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; } # Zotero Connector
      { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # MetaMask
      { id = "dcpihecpambacapedldabdbpakmachpb"; updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml"; }
    ];
  };
}
