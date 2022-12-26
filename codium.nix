{ config, pkgs, lib, ... }:
{
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "vscode-extension-ms-toolsai-jupyter"
  #];

  home.packages = let
    vscodeExtensions = (with pkgs.vscode-extensions; [
      bbenoist.nix
      ms-python.python
      redhat.vscode-yaml
      cmschuetz12.wal
      alanz.vscode-hie-server
      justusadam.language-haskell
      vscodevim.vim
      llvm-org.lldb-vscode
    ])
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "lean";
      vscodeExtPublisher = "jroesch";
      publisher = "jroesch";
      version = "0.16.22";
      sha256 = "08fj7h6dw56s40l9fkn4xz1valxpwhc4n8vw7d44264cabcsmkrw";
    }];
    #vscodium-with-extensions = pkgs.vscode-with-extensions.override {
    #  vscode = pkgs.vscodium;
    #  inherit vscodeExtensions;
    #};
    #all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  in [
    # (all-hies.selection { selector = p: { inherit (p) ghc882 ghc865; }; })
    # vscodium-with-extensions
  ];
}
