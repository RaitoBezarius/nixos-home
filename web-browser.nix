{ ... }: {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "ldlghkoiihaelfnggonhjnfiabmaficg"; } # Alt+Q switcher
      { id = "dcpihecpambacapedldabdbpakmachpb"; updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml"; }
    ];
  };
}
