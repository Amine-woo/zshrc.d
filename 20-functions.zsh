#
# Function definitions in Z shell
#

function _kitty_color() {
    function __get_color() {
        if [[ `< $XDG_RUNTIME_DIR/theme` == "light" ]]
        then
            echo $colors_light[$1]
        else
            echo $colors_dark[$1]
        fi
    }

    if (( ${+KITTY_WINDOW_ID} ))
    then
        kitty @ set-colors background=$(__get_color $1)
        kitty @ set-background-opacity $2

        shift 2
        "$@"

        kitty @ set-colors -a -c ~/.config/kitty/kitty.conf
        kitty @ set-background-opacity $c_kitty_opacity[`< $XDG_RUNTIME_DIR/theme`]
    else
        shift 2
        "$@"
    fi
}

function bat() {
    export BAT_THEME=$([[ `< $XDG_RUNTIME_DIR/theme` == "light" ]] && <<< "Monokai Extended Light")
    $(which -p bat) "$@"
}

function b() {
    lang=$1

    shift 1
    bat -l$lang --style numbers "$@"
}

function duf() {
    $(which -p duf) -theme "$(<$XDG_RUNTIME_DIR/theme)" "$@"
}

function fetch() {
    neofetch --source ${c_fetch_image[`< $XDG_RUNTIME_DIR/theme`]} "$c_fetch_argextra[@]"
}

function ifetch() {
    image=$1
    shift 1
    neofetch --source $image "$@"
}

function t() {
    twurl -d "status=$1" /1.1/statuses/update.json > /dev/null
}                           # Tweet to @sola10_mp4 instantly

function '$'() {
    a=
    while true
    do
        echo -n "$@> "
        read a
        { [[ "$a" =~ 'exit' ]] && break; } || eval "$@ $a"
    done
}                           # Turn any command into a prompt

function surf-md() {
    TARGET=$(mktemp "surf-md.XXXXXXXXXX.html" --tmpdir)
    pandoc -f markdown -t html $1 > $TARGET
    surf $TARGET
    rm $TARGET
}

function qr-echo() {
    QRFILE=$(mktemp "qr-echo.XXXXXXXXXX.png" --tmpdir)
    qrencode "$@" -o $QRFILE
    kitty +kitten icat $QRFILE
    rm $QRFILE
}

function is() {
    builtin type -f "$@" | bat -lzsh --style numbers
}
