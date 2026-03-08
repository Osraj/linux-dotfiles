#!/usr/bin/env bash
# Interactive TUI menu for dotfiles installer
# Supports: dialog > whiptail > pure-bash fallback

# --- Data Model ---

ALL_TOOLS=(devtools yay fonts zsh nvim tmux sway hyprland i3 ghostty wezterm vscodium essential miniconda)

declare -A TOOL_DESC=(
    [devtools]="Dev tools (git, stow, fzf, ripgrep, curl, wget)"
    [yay]="AUR helper (needed for some packages)"
    [fonts]="Fonts (Nerd Fonts, Fira, Cascadia, Noto...)"
    [zsh]="Zsh (Oh My Zsh + Powerlevel10k)"
    [nvim]="Neovim (built from source)"
    [tmux]="Tmux + Tmuxifier"
    [sway]="Sway (Wayland WM)"
    [hyprland]="Hyprland (Wayland compositor)"
    [i3]="i3 (X11 WM)"
    [ghostty]="Ghostty (terminal emulator)"
    [wezterm]="WezTerm (terminal emulator)"
    [vscodium]="VSCodium (editor)"
    [essential]="Essential packages (browsers, dev tools, audio)"
    [miniconda]="Miniconda (Python env manager)"
)

declare -A TOOL_DEPS=(
    [yay]="devtools"
    [fonts]="devtools"
    [zsh]="devtools"
    [nvim]="devtools"
    [tmux]="devtools"
    [sway]="devtools"
    [hyprland]="devtools"
    [i3]="devtools"
    [ghostty]="devtools yay"
    [wezterm]="devtools yay"
    [vscodium]="devtools yay"
    [essential]="devtools yay"
    [miniconda]="devtools"
)

declare -A MODE_TOOLS=(
    [minimal]="devtools zsh nvim tmux fonts"
    [work]="devtools yay zsh nvim tmux fonts ghostty vscodium essential miniconda"
    [gaming]="devtools yay zsh nvim tmux fonts hyprland ghostty essential"
    [full]="devtools yay fonts zsh nvim tmux sway hyprland i3 ghostty wezterm vscodium essential miniconda"
    [custom]=""
)

declare -A MODE_DESC=(
    [minimal]="Shell + editor essentials"
    [work]="Full dev environment"
    [gaming]="Hyprland gaming setup"
    [full]="Everything"
    [custom]="Pick your own"
)

MODE_ORDER=(minimal work gaming full custom)

# --- Selected state ---
declare -A SELECTED=()

init_selection() {
    local mode="$1"
    for tool in "${ALL_TOOLS[@]}"; do
        SELECTED[$tool]=off
    done
    if [[ -n "${MODE_TOOLS[$mode]:-}" ]]; then
        for tool in ${MODE_TOOLS[$mode]}; do
            SELECTED[$tool]=on
        done
    fi
    # devtools is always required
    SELECTED[devtools]=on
}

resolve_deps() {
    local changed=true
    while [[ "$changed" == true ]]; do
        changed=false
        for tool in "${ALL_TOOLS[@]}"; do
            if [[ "${SELECTED[$tool]}" == on && -n "${TOOL_DEPS[$tool]:-}" ]]; then
                for dep in ${TOOL_DEPS[$tool]}; do
                    if [[ "${SELECTED[$dep]}" != on ]]; then
                        SELECTED[$dep]=on
                        changed=true
                    fi
                done
            fi
        done
    done
}

get_selected_tools() {
    local result=()
    for tool in "${ALL_TOOLS[@]}"; do
        if [[ "${SELECTED[$tool]}" == on ]]; then
            result+=("$tool")
        fi
    done
    echo "${result[*]}"
}

# --- TUI Backend Detection ---

detect_tui() {
    if command -v dialog &>/dev/null; then
        echo "dialog"
    elif command -v whiptail &>/dev/null; then
        echo "whiptail"
    else
        echo "bash"
    fi
}

# --- Dialog/Whiptail Backend ---

dialog_mode_select() {
    local tui="$1"
    local items=()
    local first=true
    for mode in "${MODE_ORDER[@]}"; do
        if [[ "$first" == true ]]; then
            items+=("$mode" "${MODE_DESC[$mode]}" "on")
            first=false
        else
            items+=("$mode" "${MODE_DESC[$mode]}" "off")
        fi
    done

    local result
    result=$("$tui" --title "Dotfiles Installer" \
        --radiolist "Select installation mode:" 15 60 5 \
        "${items[@]}" 3>&1 1>&2 2>&3) || return 1
    echo "$result"
}

dialog_tool_select() {
    local tui="$1"
    local items=()
    for tool in "${ALL_TOOLS[@]}"; do
        local state="${SELECTED[$tool]}"
        items+=("$tool" "${TOOL_DESC[$tool]}" "$state")
    done

    local result
    result=$("$tui" --title "Select Tools" \
        --checklist "Space to toggle, Enter to confirm.\n'devtools' is always installed." 22 70 14 \
        "${items[@]}" 3>&1 1>&2 2>&3) || return 1

    # Clear all, then set selected
    for tool in "${ALL_TOOLS[@]}"; do
        SELECTED[$tool]=off
    done
    for tool in $result; do
        # dialog quotes items, strip them
        tool="${tool//\"/}"
        SELECTED[$tool]=on
    done
    SELECTED[devtools]=on
}

# --- Pure Bash Fallback ---

bash_mode_select() {
    local current=0
    local count=${#MODE_ORDER[@]}

    # Save terminal state
    local saved_stty
    saved_stty=$(stty -g)
    trap 'stty "$saved_stty"; tput cnorm' EXIT INT TERM

    tput civis  # hide cursor

    while true; do
        tput clear
        echo "╔══════════════════════════════════════════╗"
        echo "║       Dotfiles Installer - Mode          ║"
        echo "╠══════════════════════════════════════════╣"
        echo "║  ↑/↓ Navigate   Enter: Select           ║"
        echo "╚══════════════════════════════════════════╝"
        echo ""

        for i in "${!MODE_ORDER[@]}"; do
            local mode="${MODE_ORDER[$i]}"
            if [[ $i -eq $current ]]; then
                printf "  \033[7m > %-10s %s \033[0m\n" "$mode" "${MODE_DESC[$mode]}"
            else
                printf "    %-10s %s\n" "$mode" "${MODE_DESC[$mode]}"
            fi
        done

        # Read key
        IFS= read -rsn1 key
        case "$key" in
            $'\x1b')
                read -rsn2 key
                case "$key" in
                    '[A') ((current > 0)) && ((current--)) ;;
                    '[B') ((current < count - 1)) && ((current++)) ;;
                esac
                ;;
            '')  # Enter
                stty "$saved_stty"
                tput cnorm
                trap - EXIT INT TERM
                echo "${MODE_ORDER[$current]}"
                return 0
                ;;
            'q')
                stty "$saved_stty"
                tput cnorm
                trap - EXIT INT TERM
                return 1
                ;;
        esac
    done
}

bash_tool_select() {
    local current=0
    local count=${#ALL_TOOLS[@]}

    local saved_stty
    saved_stty=$(stty -g)
    trap 'stty "$saved_stty"; tput cnorm' EXIT INT TERM

    tput civis

    while true; do
        tput clear
        echo "╔══════════════════════════════════════════════════════════╗"
        echo "║       Dotfiles Installer - Select Tools                  ║"
        echo "╠══════════════════════════════════════════════════════════╣"
        echo "║  ↑/↓ Navigate   Space: Toggle   Enter: Confirm   q: Quit║"
        echo "╚══════════════════════════════════════════════════════════╝"
        echo ""

        for i in "${!ALL_TOOLS[@]}"; do
            local tool="${ALL_TOOLS[$i]}"
            local check=" "
            [[ "${SELECTED[$tool]}" == on ]] && check="x"
            local suffix=""
            [[ "$tool" == "devtools" ]] && suffix=" (REQUIRED)"

            if [[ $i -eq $current ]]; then
                printf "  \033[7m [%s] %-12s %s%s \033[0m\n" "$check" "$tool" "${TOOL_DESC[$tool]}" "$suffix"
            else
                printf "   [%s] %-12s %s%s\n" "$check" "$tool" "${TOOL_DESC[$tool]}" "$suffix"
            fi
        done

        IFS= read -rsn1 key
        case "$key" in
            $'\x1b')
                read -rsn2 key
                case "$key" in
                    '[A') ((current > 0)) && ((current--)) ;;
                    '[B') ((current < count - 1)) && ((current++)) ;;
                esac
                ;;
            ' ')  # Space - toggle
                local tool="${ALL_TOOLS[$current]}"
                if [[ "$tool" != "devtools" ]]; then
                    if [[ "${SELECTED[$tool]}" == on ]]; then
                        SELECTED[$tool]=off
                    else
                        SELECTED[$tool]=on
                    fi
                fi
                ;;
            '')  # Enter - confirm
                stty "$saved_stty"
                tput cnorm
                trap - EXIT INT TERM
                SELECTED[devtools]=on
                return 0
                ;;
            'q')
                stty "$saved_stty"
                tput cnorm
                trap - EXIT INT TERM
                return 1
                ;;
        esac
    done
}

# --- Confirmation & Execution ---

print_summary() {
    echo ""
    echo "=============================="
    echo "  Selected tools to install:"
    echo "=============================="
    for tool in "${ALL_TOOLS[@]}"; do
        if [[ "${SELECTED[$tool]}" == on ]]; then
            printf "  [x] %-12s %s\n" "$tool" "${TOOL_DESC[$tool]}"
        fi
    done
    echo "=============================="
    if [[ "${DRY_RUN:-false}" == true ]]; then
        echo "  Mode: DRY RUN (no changes)"
    fi
    echo ""
}

confirm_install() {
    print_summary
    read -rp "Proceed with installation? [Y/n] " answer
    case "$answer" in
        [nN]*) return 1 ;;
        *) return 0 ;;
    esac
}

execute_install() {
    local distro="$1"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    for tool in "${ALL_TOOLS[@]}"; do
        if [[ "${SELECTED[$tool]}" == on ]]; then
            local script="$script_dir/$distro/$tool.sh"
            if [[ -f "$script" ]]; then
                echo ""
                echo "========================================="
                echo "  Installing: $tool"
                echo "========================================="
                bash "$script"
            else
                echo "    Warning: $script not found, skipping $tool"
            fi
        fi
    done

    echo ""
    echo "========================================="
    echo "  Installation complete!"
    echo "========================================="
    echo "  Restart your terminal for all changes to take effect."
}

# --- Entry Point ---

run_interactive_menu() {
    local distro="$1"
    local tui
    tui=$(detect_tui)

    echo "Using TUI backend: $tui"
    echo ""

    # Step 1: Mode selection
    local mode
    if [[ "$tui" == "bash" ]]; then
        mode=$(bash_mode_select) || { echo "Cancelled."; exit 1; }
    else
        mode=$(dialog_mode_select "$tui") || { echo "Cancelled."; exit 1; }
    fi

    echo "Selected mode: $mode"
    init_selection "$mode"

    # Step 2: Tool checklist
    if [[ "$tui" == "bash" ]]; then
        bash_tool_select || { echo "Cancelled."; exit 1; }
    else
        dialog_tool_select "$tui" || { echo "Cancelled."; exit 1; }
    fi

    # Step 3: Resolve dependencies
    resolve_deps

    # Step 4: Confirm
    confirm_install || { echo "Cancelled."; exit 1; }

    # Step 5: Execute
    execute_install "$distro"
}
