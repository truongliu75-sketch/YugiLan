#!/bin/sh
# ============================================================
#  Universal Tailscale Manager
#  Supports: R36S (ArkOS), muOS, Trimui (Brick / Smart Pro / Smart ...)
#  Auto-detects OS / device / CPU arch and installs accordingly.
#  Based on the R36S Tailscale Manager by SjslTech.
# ============================================================

VERSION_FALLBACK="1.80.2"   # used only if the latest version cannot be detected

# --- Root ---
if [ "$(id -u)" -ne 0 ]; then
    command -v sudo >/dev/null 2>&1 && exec sudo -- "$0" "$@"
fi

SCRIPT_PATH=$(readlink -f "$0" 2>/dev/null || echo "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
SCRIPT_NAME=$(basename "$SCRIPT_PATH")

# --- Pick a console TTY ---
TTY=""
for t in /dev/tty0 /dev/tty1; do
    if [ -w "$t" ]; then TTY="$t"; break; fi
done
[ -z "$TTY" ] && TTY=/dev/tty
exec <"$TTY" >"$TTY" 2>&1
printf '\033c'
export TERM=linux

# ============================================================
#  DEVICE / OS DETECTION
# ============================================================
detect_device() {
    MODEL=""
    [ -r /proc/device-tree/model ] && MODEL=$(tr -d '\0' </proc/device-tree/model 2>/dev/null)
    CPUINFO=$(cat /proc/cpuinfo 2>/dev/null)
    OSREL=$(cat /etc/os-release 2>/dev/null)
    ALL="$MODEL $CPUINFO $OSREL $(uname -a 2>/dev/null)"

    case "$(uname -m)" in
        aarch64|arm64) ARCH=arm64 ;;
        armv7*|armv6*|armv5*|arm*) ARCH=arm ;;
        x86_64) ARCH=amd64 ;;
        *) ARCH="" ;;
    esac

    # OS
    if [ -d /mnt/mmc/MUOS ] || [ -d /opt/muos ] || echo "$OSREL" | grep -qi muos; then
        OS_NAME="muOS"
    elif [ -d /opt/inttools ] || echo "$OSREL" | grep -qi arkos; then
        OS_NAME="ArkOS"
    elif [ -d /mnt/SDCARD/.system ] || [ -d /mnt/SDCARD/Tools ] || [ -d /usr/trimui ]; then
        OS_NAME="TrimUI"
    else
        OS_NAME="Linux"
    fi

    # Device
    case "$ALL" in
        *tg5040*|*TG5040*) DEVICE="Trimui Brick/Smart Pro"; SLUG="trimui-tg5040" ;;
        *tg3040*|*TG3040*) DEVICE="Trimui Smart";           SLUG="trimui-tg3040" ;;
        *tg3568*|*TG3568*) DEVICE="Trimui Model S";         SLUG="trimui-tg3568" ;;
        *[Tt]rimui*|*TRIMUI*) DEVICE="Trimui";              SLUG="trimui" ;;
        *R36S*|*r36s*|*rk3326*|*RK3326*) DEVICE="R36S";     SLUG="r36s" ;;
        *) DEVICE="${MODEL:-Unknown device}"; SLUG="handheld" ;;
    esac
    [ "$OS_NAME" = "muOS" ] && SLUG="muos-$SLUG"
    TS_HOST=$(echo "$SLUG" | tr 'A-Z_ ' 'a-z--')

    # Install mode: systemd+apt (ArkOS/Debian) or static binaries (muOS/Trimui/others)
    if command -v systemctl >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
        MODE=apt
    else
        MODE=static
    fi

    DATA_DIR="$SCRIPT_DIR/tailscale_data"
    BIN_DIR="$DATA_DIR/bin"
    SOCK="/tmp/tailscaled.sock"          # sockets don't work on FAT/exFAT -> use /tmp
    PIDFILE="/tmp/tailscaled.pid"
    RUN_BIN="$BIN_DIR"
    BACKTITLE="Tailscale Manager | $OS_NAME | $DEVICE | $ARCH | mode:$MODE"
}
detect_device

# ============================================================
#  CONTROLLER INPUT (gptokeyb if available)
# ============================================================
GPTK_PID=""
start_input() {
    for d in /opt/inttools /mnt/mmc/MUOS/PortMaster /mnt/sdcard/MUOS/PortMaster \
             /mnt/SDCARD/Apps/PortMaster /roms/ports/PortMaster /opt/system/Tools/PortMaster; do
        if [ -x "$d/gptokeyb" ] || [ -f "$d/gptokeyb" ]; then
            [ -e /dev/uinput ] && chmod 666 /dev/uinput 2>/dev/null
            [ -f "$d/gamecontrollerdb.txt" ] && export SDL_GAMECONTROLLERCONFIG_FILE="$d/gamecontrollerdb.txt"
            KEYS="$d/keys.gptk"
            if [ ! -f "$KEYS" ]; then
                KEYS=/tmp/ts_keys.gptk
                printf 'up = up\ndown = down\nleft = left\nright = right\na = enter\nb = esc\n' > "$KEYS"
            fi
            chmod +x "$d/gptokeyb" 2>/dev/null
            "$d/gptokeyb" -1 "$SCRIPT_NAME" -c "$KEYS" >/dev/null 2>&1 &
            GPTK_PID=$!
            return
        fi
    done
}
start_input

cleanup() {
    [ -n "$GPTK_PID" ] && kill "$GPTK_PID" 2>/dev/null
    stty sane <"$TTY" 2>/dev/null
    printf '\033c\033[?25h'
}
trap cleanup EXIT
trap 'exit 0' INT TERM
printf '\033[?25l'

# ============================================================
#  UI LAYER  (dialog if present, otherwise built-in text UI)
# ============================================================
HAS_DIALOG=0
command -v dialog >/dev/null 2>&1 && HAS_DIALOG=1

# returns UP / DOWN / ENTER / BACK
read_key() {
    stty -echo -icanon min 1 time 0 <"$TTY" 2>/dev/null
    k=$(dd bs=1 count=1 2>/dev/null <"$TTY")
    if [ -z "$k" ] || [ "$k" = "$(printf '\r')" ]; then echo ENTER; return; fi
    if [ "$k" = "$(printf '\033')" ]; then
        stty -icanon min 0 time 1 <"$TTY" 2>/dev/null
        rest=$(dd bs=1 count=2 2>/dev/null <"$TTY")
        case "$rest" in
            "[A") echo UP ;;
            "[B") echo DOWN ;;
            *) echo BACK ;;
        esac
        return
    fi
    case "$k" in
        k|K) echo UP ;;
        j|J) echo DOWN ;;
        *) echo OTHER ;;
    esac
}

txt() { printf '%b' "$(printf '%s' "$1" | sed 's/\\Z1/\\033[31m/g; s/\\Zn/\\033[0m/g')"; }

ui_msg() {
    if [ "$HAS_DIALOG" = 1 ]; then
        dialog --colors --msgbox "$1" 16 70
    else
        printf '\033c'; txt "$1"; printf '\n\n[A/Enter] OK\n'
        while :; do [ "$(read_key)" = ENTER ] && break; done
    fi
}

ui_info() {
    if [ "$HAS_DIALOG" = 1 ]; then
        dialog --colors --infobox "$1" 7 60
    else
        printf '\033c'; txt "$1"; printf '\n'
    fi
}

ui_yesno() {
    if [ "$HAS_DIALOG" = 1 ]; then
        dialog --yesno "$1" 8 55; return $?
    fi
    printf '\033c'; txt "$1"; printf '\n\n[A/Enter] Yes    [B/Esc] No\n'
    while :; do
        case "$(read_key)" in ENTER) return 0 ;; BACK) return 1 ;; esac
    done
}

# ui_menu "Title" tag1 label1 tag2 label2 ...  -> prints chosen tag
ui_menu() {
    title="$1"; shift
    if [ "$HAS_DIALOG" = 1 ]; then
        dialog --colors --backtitle "$BACKTITLE" --title " $title " \
               --menu "Select an option:" 17 64 8 "$@" --output-fd 1
        return
    fi
    LIST=""
    while [ $# -ge 2 ]; do LIST="$LIST$1|$2
"; shift 2; done
    n=$(printf '%s' "$LIST" | grep -c .)
    sel=1
    while :; do
        printf '\033c'
        printf '%s\n== %s ==\n\n' "$BACKTITLE" "$title"
        i=1
        printf '%s' "$LIST" | while IFS='|' read -r tag label; do
            [ -z "$tag" ] && continue
            if [ "$i" -eq "$sel" ]; then printf ' > \033[7m %s \033[0m\n' "$label"
            else printf '    %s\n' "$label"; fi
            i=$((i+1))
        done
        printf '\n[Up/Down] move  [A/Enter] select\n'
        case "$(read_key)" in
            UP)   sel=$((sel-1)); [ "$sel" -lt 1 ] && sel=$n ;;
            DOWN) sel=$((sel+1)); [ "$sel" -gt "$n" ] && sel=1 ;;
            ENTER) printf '%s' "$LIST" | sed -n "${sel}p" | cut -d'|' -f1; return ;;
        esac
    done
}

# ============================================================
#  TAILSCALE HELPERS
# ============================================================
dl() { # dl URL OUTFILE
    if command -v curl >/dev/null 2>&1; then curl -fsSL -o "$2" "$1"
    elif command -v wget >/dev/null 2>&1; then wget -qO "$2" "$1"
    else return 1; fi
}

ts() {
    if [ "$MODE" = apt ]; then tailscale "$@"
    else "$RUN_BIN/tailscale" --socket="$SOCK" "$@"; fi
}

is_installed() {
    if [ "$MODE" = apt ]; then command -v tailscale >/dev/null 2>&1
    else [ -f "$BIN_DIR/tailscaled" ] && [ -f "$BIN_DIR/tailscale" ]; fi
}

# Make sure the binaries can be executed (FAT/exFAT SD cards cannot hold +x)
prep_bin() {
    chmod +x "$BIN_DIR"/tailscale "$BIN_DIR"/tailscaled 2>/dev/null
    if "$BIN_DIR/tailscaled" --version >/dev/null 2>&1; then RUN_BIN="$BIN_DIR"; return 0; fi
    mkdir -p /tmp/tailscale_bin
    cp "$BIN_DIR"/tailscale "$BIN_DIR"/tailscaled /tmp/tailscale_bin/ 2>/dev/null
    chmod +x /tmp/tailscale_bin/* 2>/dev/null
    if /tmp/tailscale_bin/tailscaled --version >/dev/null 2>&1; then RUN_BIN=/tmp/tailscale_bin; return 0; fi
    return 1
}

daemon_running() {
    if [ "$MODE" = apt ]; then systemctl is-active --quiet tailscaled
    else [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null && [ -S "$SOCK" ]; fi
}

start_daemon() {
    if [ "$MODE" = apt ]; then systemctl start tailscaled; return $?; fi
    is_installed || return 1
    daemon_running && return 0
    prep_bin || return 1
    rm -f "$SOCK"
    mkdir -p "$DATA_DIR"
    # userspace-networking: works even when the kernel has no TUN module
    if command -v setsid >/dev/null 2>&1; then
        setsid "$RUN_BIN/tailscaled" --tun=userspace-networking \
            --state="$DATA_DIR/tailscaled.state" --socket="$SOCK" \
            >"$DATA_DIR/tailscaled.log" 2>&1 &
    else
        "$RUN_BIN/tailscaled" --tun=userspace-networking \
            --state="$DATA_DIR/tailscaled.state" --socket="$SOCK" \
            >"$DATA_DIR/tailscaled.log" 2>&1 &
    fi
    echo $! > "$PIDFILE"
    c=0
    while [ $c -lt 15 ]; do
        [ -S "$SOCK" ] && return 0
        sleep 1; c=$((c+1))
    done
    return 1
}

stop_daemon() {
    if [ "$MODE" = apt ]; then systemctl stop tailscaled 2>/dev/null; return; fi
    [ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null
    rm -f "$PIDFILE" "$SOCK"
}

install_static() {
    if [ -z "$ARCH" ]; then ui_msg "Unsupported CPU: $(uname -m)"; return 1; fi
    mkdir -p "$BIN_DIR"

    # Offline install: drop tailscale_x.y.z_ARCH.tgz next to this script
    TGZ=$(ls "$SCRIPT_DIR"/tailscale_*_"$ARCH".tgz 2>/dev/null | head -n 1)
    if [ -z "$TGZ" ]; then
        ui_info "Checking latest Tailscale version ($ARCH)..."
        dl "https://pkgs.tailscale.com/stable/" /tmp/ts_index.html 2>/dev/null
        FILE=$(grep -o "tailscale_[0-9.]*_${ARCH}\.tgz" /tmp/ts_index.html 2>/dev/null | head -n 1)
        [ -z "$FILE" ] && FILE="tailscale_${VERSION_FALLBACK}_${ARCH}.tgz"
        ui_info "Downloading $FILE ...\nThis may take a moment."
        if ! dl "https://pkgs.tailscale.com/stable/$FILE" "/tmp/$FILE"; then
            ui_msg "Download failed.\n\nCheck Wi-Fi, or download\n$FILE\nfrom pkgs.tailscale.com/stable/\nand put it next to this script."
            return 1
        fi
        TGZ="/tmp/$FILE"
    fi

    rm -rf /tmp/ts_extract; mkdir -p /tmp/ts_extract
    tar -xzf "$TGZ" -C /tmp/ts_extract || { ui_msg "Extract failed."; return 1; }
    T=$(find /tmp/ts_extract -type f -name tailscale | head -n 1)
    D=$(find /tmp/ts_extract -type f -name tailscaled | head -n 1)
    if [ -z "$T" ] || [ -z "$D" ]; then ui_msg "Archive content invalid."; return 1; fi
    cp "$T" "$D" "$BIN_DIR"/ && chmod +x "$BIN_DIR"/tailscale "$BIN_DIR"/tailscaled 2>/dev/null
    rm -rf /tmp/ts_extract /tmp/tailscale_*.tgz /tmp/ts_index.html
    return 0
}

get_auth_url() {
    # run `tailscale up` in background and wait for the login URL
    rm -f /tmp/ts_auth
    ts up --hostname="$TS_HOST" --accept-dns=false > /tmp/ts_auth 2>&1 &
    c=0; AUTH_URL=""
    while [ $c -lt 20 ]; do
        AUTH_URL=$(grep -o 'https://login.tailscale.com/a/[^ ]*' /tmp/ts_auth 2>/dev/null | sed 's/[[:punct:]]$//' | head -n 1)
        [ -n "$AUTH_URL" ] && break
        sleep 1; c=$((c+1))
    done
}

# ============================================================
#  MENU ACTIONS
# ============================================================
ShowStatus() {
    if ! is_installed; then ui_msg "Tailscale is not installed."; return; fi
    if ! daemon_running; then ui_msg "Tailscale service is STOPPED.\n\nUse 'Start Tailscale Service'."; return; fi
    TS_IP=$(ts ip -4 2>/dev/null | head -n 1)
    TS_STATUS=$(ts status --peers=false 2>/dev/null)
    if [ -z "$TS_IP" ]; then
        ui_msg "Tailscale is OFFLINE or UNLINKED.\n\nUse 'Install / Link' to get a login URL."
    else
        ui_msg "Tailscale is ONLINE\n\nHost: $TS_HOST\nIP: $TS_IP\n\nStatus:\n$TS_STATUS"
    fi
}

InstallTailscale() {
    if ! is_installed; then
        if [ "$MODE" = apt ]; then
            ui_info "Downloading and installing Tailscale...\nThis may take a moment."
            curl -fsSL https://tailscale.com/install.sh | sh >/dev/null 2>&1 \
                || { ui_msg "Installation failed. Check your internet connection."; return; }
        else
            install_static || return
        fi
    fi

    ui_info "Starting Tailscale service..."
    if ! start_daemon; then
        ui_msg "Could not start tailscaled.\nLog: $DATA_DIR/tailscaled.log"
        return
    fi

    if [ -n "$(ts ip -4 2>/dev/null | head -n 1)" ]; then
        ui_msg "This device is already linked.\n\nIP: $(ts ip -4 2>/dev/null | head -n 1)"
        return
    fi

    ui_info "Fetching Link URL..."
    get_auth_url
    if [ -n "$AUTH_URL" ]; then
        ui_msg "\nVisit this URL on your phone or PC:\n\n\\Z1$AUTH_URL\\Zn\n\nPress OK once you have authorized the device."
    else
        ui_msg "Tailscale started, but the link timed out.\nPlease try 'Install / Link' again."
    fi
    rm -f /tmp/ts_auth
}

UninstallTailscale() {
    ui_yesno "Completely remove Tailscale?" || return
    ui_info "Removing Tailscale and configuration..."
    if [ "$MODE" = apt ]; then
        systemctl stop tailscaled 2>/dev/null
        apt-get remove -y tailscale >/dev/null 2>&1
        rm -rf /var/lib/tailscale /etc/tailscale
    else
        stop_daemon
        rm -rf "$DATA_DIR" /tmp/tailscale_bin
    fi
    ui_msg "Tailscale has been fully removed."
}

# ============================================================
#  MAIN MENU
# ============================================================
while :; do
    CHOICE=$(ui_menu "MAIN MENU" \
        1 "Check Status / View IP" \
        2 "Install / Link (Show URL)" \
        3 "Stop Tailscale Service" \
        4 "Start Tailscale Service" \
        5 "Uninstall Tailscale" \
        6 "Exit")

    case "$CHOICE" in
        1) ShowStatus ;;
        2) InstallTailscale ;;
        3) stop_daemon; ui_info "Service stopped."; sleep 1 ;;
        4)
            if is_installed; then
                if start_daemon; then ui_info "Service started."; else ui_info "Failed to start."; fi
            else
                ui_info "Tailscale is not installed."
            fi
            sleep 1 ;;
        5) UninstallTailscale ;;
        *) exit 0 ;;
    esac
done
