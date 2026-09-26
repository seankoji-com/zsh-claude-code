# shellcheck shell=bash disable=all
Describe 'zsh-claude-code.plugin.zsh'
  Include ./zsh-claude-code.plugin.zsh

  Describe 'completions'
    It 'adds its completions directory to fpath'
      When call print -r -- "${fpath[(r)*zsh-claude-code/completions]}"
      The output should end with 'zsh-claude-code/completions'
    End

    It 'ships a completion file for the right commands'
      When call head -1 completions/_claude
      The output should equal '#compdef claude claude-code'
    End

    # A bare compdef call before compinit is silently discarded, so the
    # registrations are deferred to a precmd hook instead.
    It 'defers registration when compdef does not exist yet'
      When call print -r -- "${precmd_functions[(r)_zsh_claude_code_late_compdef]}"
      The output should equal '_zsh_claude_code_late_compdef'
    End

    It 'removes its own deferral hook once it has run'
      run_it() {
        compdef() { :; }
        _zsh_claude_code_late_compdef
        print -r -- "[${precmd_functions[(r)_zsh_claude_code_late_compdef]}]"
      }
      When call run_it
      The output should equal '[]'
    End
  End

  Describe 'aliases'
    It 'defines cld'
      When call print -r -- "${aliases[cld]}"
      The output should equal 'claude'
    End

    # cc is the C compiler; the plugin must not shadow it unless asked to.
    It 'leaves cc alone by default'
      When call print -r -- "[${aliases[cc]}]"
      The output should equal '[]'
    End

    It 'defines cc when the zstyle opts in'
      run_it() {
        zsh -f -c '
          zstyle ":zsh-claude-code:aliases" cc yes
          source ./zsh-claude-code.plugin.zsh
          print -r -- "${aliases[cc]}"
        '
      }
      When call run_it
      The output should equal 'claude'
    End

    Describe 'removed aliases'
      Parameters
        ccc
        cca
        cccfg
      End

      # claude has no chat, api or config subcommands.
      It "does not define $1"
        When call print -r -- "[${aliases[$1]}]"
        The output should equal '[]'
      End
    End
  End
End
