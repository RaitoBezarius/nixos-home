# Remove default alias.
unalias tree
function tree {
     br -c :pt "$@"
}

function dcd {
    br --only-folders --cmd "$1;:cd"
}
