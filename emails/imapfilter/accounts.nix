{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.imapfilter;
in
{
  options.imapfilter = {
    enable = mkEnableOption "filtering using imapfilter";
    filterScriptFile = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
