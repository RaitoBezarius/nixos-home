# Local development of nixpkgs
export LOCAL_NIXPKGS_CHECKOUT="$HOME/dev/github.com/NixOS/nixpkgs"
export GITHUB_TOKEN=$(gh auth token)

function nrs() (
	cd ~cfg-mono
	colmena apply-local --sudo --verbose
)

function npr() (
	cd ~lnixpkgs
	nixpkgs-review pr --post-result "$@"
)

function nprs() (
	cd ~lnixpkgs
	declare -a supported_systems=("x86_64-linux" "i686-linux" "aarch64-darwin" "x86_64-darwin")
	for system in "${supported_systems[@]}"
	do
		echo "Evaluating on $system...";
		nixpkgs-review pr --post-result --system "$system" "$@";
	done
)

function darwin-nprs() (
	cd ~lnixpkgs
	declare -a supported_systems=("aarch64-darwin" "x86_64-darwin")
	for system in "${supported_systems[@]}"
	do
		echo "Evaluating on $system..."
		nixpkgs-review pr --post-result --system "$system" "$@"
	done
)

function linux-nprs() (
	cd ~lnixpkgs
	declare -a supported_systems=("x86_64-linux" "i686-linux")
	for system in "${supported_systems[@]}"
	do
		echo "Evaluating on $system..."
		nixpkgs-review pr --post-result --system "$system" "$@"
	done
)


function nix-rback() {
	sudo nix-channel --rollback
	red "Rollbacking nixpkgs to $(nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version') version."
}
