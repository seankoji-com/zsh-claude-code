# shellcheck shell=bash disable=all
# Spot checks that completions/_claude tracks `claude --help`. The weekly
# completion-drift workflow does the full comparison against the live CLI.
Describe 'completions/_claude'
  spec_line() { grep -F -- "$1" completions/_claude | head -1; }

  It 'offers the permission modes the CLI accepts'
    When call spec_line "'--permission-mode[Permission mode for the session]"
    The output should include ':mode:(acceptEdits auto bypassPermissions manual dontAsk plan)'
  End

  It 'offers every effort level'
    When call spec_line "'--effort[Effort level for the current session]"
    The output should include ':level:(low medium high xhigh max)'
  End

  Describe 'new flags'
    Parameters
      --bare
      --bg
      --background
      --name
      --remote-control
      --safe-mode
      --teleport
      --permission-prompts
      --cloud
    End

    It "completes the $1 flag"
      When call grep -cE -- "(^|[^a-z-])$1([^a-z-]|\$)" completions/_claude
      The output should not equal 0
    End
  End

  Describe 'subcommands'
    Parameters
      attach
      auto-mode
      gateway
      import
      logs
      project
      respawn
      rm
      stop
      kill
      ultrareview
      update
    End

    It "lists the $1 subcommand"
      When call grep -cF -- "'$1:" completions/_claude
      The output should not equal 0
    End
  End

  Describe 'removed flags'
    Parameters
      --mcp-debug
      --allowed
      --disallowed
    End

    It "no longer offers the removed $1 flag"
      When call grep -cE -- "$1([^a-zA-Z-]|\$)" completions/_claude
      The output should equal 0
      The status should be failure
    End
  End

  It 'loads without errors'
    When call zsh -n completions/_claude
    The status should be success
  End
End
