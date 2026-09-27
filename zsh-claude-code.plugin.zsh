# zsh-claude-code — completions and aliases for the Claude Code CLI.
#
# The completion body lives in completions/_claude and is autoloaded on the
# first Tab rather than sourced at startup.

0=${(%):-%N}
ZSH_CLAUDE_CODE_DIR=${0:A:h}

fpath+=("$ZSH_CLAUDE_CODE_DIR/completions")
# Register the autoload file, including when compinit ran before this plugin.
autoload -Uz _claude

# compdef only exists after compinit. When this plugin loads first, defer the
# registrations until compinit has run rather than dropping them silently,
# which is what a bare `compdef` call does here.
if (( $+functions[compdef] )); then
  compdef _claude claude-code
  compdef _claude claude
else
  autoload -Uz add-zsh-hook
  _zsh_claude_code_late_compdef() {
    (( $+functions[compdef] )) || return 0
    compdef _claude claude-code
    compdef _claude claude
    add-zsh-hook -d precmd _zsh_claude_code_late_compdef
  }
  add-zsh-hook precmd _zsh_claude_code_late_compdef
fi

# Aliases complete through their expansion, so none needs its own compdef.
#
# `cc` is the C compiler on most systems, so the plugin no longer claims it by
# default. Opt back in with:
#   zstyle ':zsh-claude-code:aliases' cc yes
alias cld='claude'
if zstyle -t ':zsh-claude-code:aliases' cc; then
  alias cc='claude'
fi
