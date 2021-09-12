function upc() (
	set -eo pipefail
	{ sudo nixos-rebuild build --upgrade && nvd diff ~nix-now result; } || (unlink result &>/dev/null; exit 1)
	if read -q "CHOICE?Upgrade? y/n "; then
		echo
		yellow "Switching now to new version."
		sudo nixos-rebuild switch
	fi
	unlink result &>/dev/null
)

function nix-rback() {
	sudo nix-channel --rollback
	red "Rollbacking nixpkgs to $(nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version') version."
}

function hupc() (
	set -eo pipefail
	nix-channel --update home-manager
	{ home-manager build "$@" && nvd diff ~nix-hm result; } || (unlink result &>/dev/null; exit 1)
	if read -q "CHOICE?Upgrade? y/n "; then
		echo
		yellow "Switching now to new version."
		home-manager switch
	fi
	unlink result &>/dev/null
)