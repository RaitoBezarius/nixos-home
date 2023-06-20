BASE="${0:A:h}"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

function red {
    printf "${RED}$@${NC}\n"
}

function green {
    printf "${GREEN}$@${NC}\n"
}

function yellow {
    printf "${YELLOW}$@${NC}\n"
}

plugins=('nix' 'vm' 'broot' 'blog' 'misc') # secrets module.

for p in $plugins; do
	source $BASE/$p.zsh
done
