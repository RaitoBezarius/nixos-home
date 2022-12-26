# Local development of nixpkgs
export LOCAL_NIXPKGS_CHECKOUT="$HOME/dev/github.com/NixOS/nixpkgs"

function nrs() (
	cd ~cfg-mono
	colmena apply-local --sudo --verbose
)

function npr() (
	cd ~lnixpkgs
	nixpkgs-review pr --post-result "$1"
)

function nix-rback() {
	sudo nix-channel --rollback
	red "Rollbacking nixpkgs to $(nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version') version."
}
