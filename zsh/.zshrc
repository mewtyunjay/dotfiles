# Optimize compinit by caching it (check once per day)
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Configure menu selection for cycling through completions with Tab
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' menu yes select

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Editor configuration
export EDITOR=nvim
export VISUAL=nvim

# Use Emacs keybindings (default)
bindkey -e

# Aliases
alias v=nvim .
alias vim=nvim
alias code25='cd ~/Code/2025'
alias zshrc='zed ~/.zshrc'
alias greene-connect="ssh-keygen -R greene.hpc.nyu.edu && ssh mb9348@greene.hpc.nyu.edu"
alias mcpinspector="npx @modelcontextprotocol/inspector"
alias kill7000='lsof -ti:7000 | xargs kill -9 2>/dev/null || echo "No process on port 7000"'
alias vpnup='sudo wg-quick up ~/wireguard/accurise.conf'
alias vpndown='sudo wg-quick down ~/wireguard/accurise.conf'
alias vpnstatus='sudo wg show'
alias ss='open ~/Documents/Screenshots'

# Autocomplete settings
source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_STRATEGY=(completion)
# source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# fzf integration (keybindings + completions)
if [[ -r "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
else
    # Homebrew-installed fzf fallback
    if [[ -r "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]]; then
        source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
    fi
    if [[ -r "/opt/homebrew/opt/fzf/shell/completion.zsh" ]]; then
        source "/opt/homebrew/opt/fzf/shell/completion.zsh"
    fi
fi

# eza aliases (beautiful ls)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza -a --icons --group-directories-first'
    alias l='eza -l --icons --git -a --group-directories-first'
    alias la='eza -la --icons --git --group-directories-first'
    alias ll='eza -l --icons --git --group-directories-first'
    alias lta='eza --tree -a --icons --git --group-directories-first'
    alias lst5='eza -1 -s modified -r | head -n 5'
fi

# Flexible eza tree functions and clipboard variants
lt() {
    # Usage: lt [LEVEL] [-a] [path]
    local level_flags=()
    local all_flag=()
    local args=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -a|--all)
                all_flag=(-a)
                shift
                ;;
            [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
                level_flags=(--level="$1")
                shift
                ;;
            *)
                args+=("$1")
                shift
                ;;
        esac
    done
    eza --tree "${level_flags[@]}" "${all_flag[@]}" --icons --git --group-directories-first "${args[@]}"
}

ltc() {
    # Usage: ltc [LEVEL] [-a] [path] -> prints and copies to clipboard
    lt "$@" | tee >(pbcopy) >/dev/null
}

# yazi: change directory to the last visited path on exit
y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# Allow dynamic lt<num>, lta<num>, and ltc<num>
command_not_found_handler() {
    setopt localoptions extendedglob
    local cmd="$1"; shift
    if [[ $cmd == lt<-> ]]; then
        local level=${cmd#lt}
        lt "$level" "$@"
        return $?
    elif [[ $cmd == lta<-> ]]; then
        local level=${cmd#lta}

        lt -a "$level" "$@"
        return $?
    elif [[ $cmd == ltc<-> ]]; then
        local level=${cmd#ltc}
        ltc "$level" "$@"
        return $?
    fi
    echo "zsh: command not found: $cmd" >&2
    return 127
}

eval "$(starship init zsh)"

# zoxide (smart cd): provides `z` and `zi` commands
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
