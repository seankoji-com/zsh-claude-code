# zsh-claude-code — completions and aliases for the Claude Code CLI.
#
# The completion body lives in completions/_claude and is autoloaded on the
# first Tab rather than sourced at startup.

0=${(%):-%N}
ZSH_CLAUDE_CODE_DIR=${0:A:h}

fpath+=("$ZSH_CLAUDE_CODE_DIR/completions")

# compdef only exists after compinit. When this plugin loads first, defer the
# registrations until compinit has run rather than dropping them silently,
# which is what a bare `compdef` call does here.
if (( $+functions[compdef] )); then
  compdef _claude_code claude-code
  compdef _claude_code claude
  compdef _claude_code cc
else
  autoload -Uz add-zsh-hook
  _zsh_claude_code_late_compdef() {
    (( $+functions[compdef] )) || return 0
    compdef _claude_code claude-code
    compdef _claude_code claude
    compdef _claude_code cc
    add-zsh-hook -d precmd _zsh_claude_code_late_compdef
  }
  add-zsh-hook precmd _zsh_claude_code_late_compdef
fi

alias cc='claude'
alias ccc='claude chat'
alias cca='claude api'
alias cccfg='claude config'
