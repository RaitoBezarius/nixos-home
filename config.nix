{
  allowUnfree = true;
  packageOverrides = pkgs: {
    raito = import (builtins.fetchTarball "https://github.com/RaitoBezarius/nixexprs/archive/master.tar.gz") {
      inherit pkgs;
    };
    raito-dev = import (~/dev/github.com/RaitoBezarius/nixexprs) {
      inherit pkgs;
    };
    rz = import (~/dev/projects/ens/club_reseau/git/nur) {
      inherit pkgs;
    };

    immae = import (fetchGit {
      url = "https://git.immae.eu/perso/Immae/Config/Nix.git";
      rev = "4b52b8a42b896cc749cf2ea4ee6822fba5380c71";
    }) {
      inherit pkgs;
    };

    nix_v6 = pkgs.nixUnstable.overrideAttrs (old: {
      suffix = "pre20210210_a487d421";
      src = pkgs.fetchFromGitHub {
        owner = "nixos";
        repo = "nix";
        rev = "a487d421019bc16d83dad66b805b550cb6b70272";
        sha256 = "11rmzq3ai9q6fhdi9jl2g81v43zr224db1wkb1s45vbccd1w9iyx";
      };
      patches = [];
    });

    #nix = pkgs.nix.overrideAttrs (old: {
    #  patches = (old.patches or []) ++ [ (builtins.fetchurl { url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/1584.patch"; sha256 = "1j5gnrykia7rkm938d1fcgx201a6qidrv7l9ba8mkx6jx34swfs9"; }) ];
    #});
  };
}
