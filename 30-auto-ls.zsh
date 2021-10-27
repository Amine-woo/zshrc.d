#
# Specific Z shell configuration for auto-ls plugin
#

function auto-ls-reset() { [[ ${WIDGET} == accept-line ]] && clear; }
function auto-ls-echo() { echo; }
function auto-ls-lsd() { lsd --group-dirs=first; }

function auto-ls-readme() {
    for f in $(find . -maxdepth 1 -iname "README*")
    do
        bat --style numbers,header --paging=never $f
        echo
    done
}

function auto-ls-onefetch() {
    if git status >/dev/null 2>&1
    then
        onefetch --image-backend kitty -i $c_gitfetch_image --no-color-palette
        git status -s
        echo
    fi
}

function auto-ls-nix-sh() {
    [[ -v NIX_SHELL_PACKAGES ]]     && return 0 # Already in shell
    [[ ${WIDGET} == accept-line ]]  && return 0 # newline widget broken
    [[ -d /nix ]]                   || return 0 # Nix isn't installed
    scanpath=$PWD
    while [[ "$(df $scanpath --output=target | tail -n 1)" == "$(df $PWD --output=target | tail -n 1)" ]] && [[ $scanpath != / ]]
    do
        find "$scanpath" -maxdepth 1 -mindepth 1 \
                     -type f         \
                     -readable       \
                     -name shell.nix \
        | grep . 2>&1 >/dev/null && \
        {
            echo -n "A Nix shell workspace was found. ($scanpath/shell.nix) Load? [y/N] "
            read -q && nix-shell $scanpath/shell.nix
            return 0
        }
        scanpath="$(readlink -f "$scanpath/..")"
    done
}

export AUTO_LS_COMMANDS=(reset readme onefetch lsd nix-sh echo)
