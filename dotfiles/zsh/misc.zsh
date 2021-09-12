function gn()
{
  curl -s https://api.greynoise.io/v3/community/$1 | jq -r '.'
}

function share() {
    if (( ${#} != 1 )); then
        echo "Usage:"
        echo "  share /path/to/file"
        echo "	cat /path/to/file | share filename"
        return 1
    fi

    if tty -s; then
        curl --progress-bar --upload-file "${1}" "https://shared.lahfa.xyz/${1##*/}"
    else
        curl --progress-bar --upload-file "-" "https://shared.lahfa.xyz/${1}"
    fi
}

function rshare() {
    if (( ${#} != 1 )); then
        echo "Usage:"
        echo "	rshare /path/to/file"
        echo "	This will REMOVE /path/to/file"
        return 1
    fi

    share "${1}" && rm "${1}"
}

