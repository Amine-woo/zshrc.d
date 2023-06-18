#
# Other commands that modify the zsh session
#

if (( ${+TMUX} ))
then
    export TERM=screen-256color         # 256color by default
fi

if [ -f $HOME/.box-name ]
then
    typeset -g POWERLEVEL9K_CONTEXT_REMOTE_TEMPLATE="$(< $HOME/.box-name) (%n)"
fi                                      # Box name (like Honukai)

function _kcolor() {
    case "${#words[@]}" in
    2)  for k in ${(k)colors_dark}
        do  compadd $k
        done
    ;;
    3)  break
    ;;
    *)  shift 3 words
        (( CURRENT -= 3))
        _normal
    ;;
    esac
}

function _is() { service=type _which; }

function _new() {
    for dir in $HOME/.templates/*
    do  compadd $(basename $dir)
    done
}

function _nix() {
    local ifs_bk="$IFS"
    local input=("${(Q)words[@]}")
    IFS=$'\t\n'
    local res=($(NIX_GET_COMPLETIONS=$((CURRENT - 1)) "$input[@]"))
    IFS="$ifs_bk"
    local tpe="$res[1]"
    local suggestions=(${res:1})
    if [[ "$tpe" == filenames ]]
    then
        compadd -fa suggestions
    else
        compadd -a suggestions
    fi
}

function _zsh_autosuggest_strategy_dirhist() {
    emulate -L zsh
    local zcmd=(${(z)1})
    if [[ "${zcmd[1]}" =~ "^[1-9]$" ]]
    then
        if [[ -v dirstack[${zcmd[1]}] ]]
        then
            typeset -g suggestion="$1 # -> ${dirstack[${zcmd[1]}]}"
        else
            typeset -g suggestion="$1 # (no stack entry)"
        fi
    fi
}

function _zsh_autosuggest_strategy_zoxide() {
    emulate -L zsh
    local zcmd=(${(z)1})
    if  [[ "${zcmd[1]}" = "cd" ]] &&\
        [[ ${#zcmd} == 2 ]]       &&\
        sugg=$(zoxide query "${zcmd[2]}" 2>/dev/null)
    then
        typeset -g suggestion="$1 # -> $sugg"
    elif [[ "${zcmd[1]}" = "z" ]] &&\
         [[ "${#zcmd}" -ge 2 ]]     &&\
         sugg=$(zoxide query "${zcmd[2]}" 2>/dev/null)
    then
        typeset -g suggestion="$@ # -> $sugg"
    fi
}

# Completion modes (controls tab behavior per-command)
compdef _precommand ,
compdef _precommand $
compdef _is is
compdef _new new
compdef _nix nix
compdef _kcolor _kitty_color

# Add comma highlighter
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main comma)

# Add directory stack strategy to autosuggest
ZSH_AUTOSUGGEST_STRATEGY=(dirhist history)

# Load Zoxide smart cd if installed
if which -p zoxide >&/dev/null
then
    eval "$(zoxide init zsh --cmd cd)"
    ZSH_AUTOSUGGEST_STRATEGY=(zoxide dirhist history)
fi
