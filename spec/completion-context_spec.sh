# shellcheck shell=bash disable=all
Describe 'completion command contexts'
  # Capture the specifications passed to zsh's _arguments in each dispatch
  # context. This catches flags placed under the wrong subcommand.
  specs_for() {
    zsh -f -c '
      _arguments() {
        print -rl -- "$@"
        if [[ $1 == -C ]]; then
          state=args
          line=($target)
        fi
      }
      _describe() { :; }
      source completions/_claude >/dev/null
      target=$1
      case $target in
        root) _claude_code ;;
        ultrareview) _claude_code ;;
        purge) _claude_code ;;
        eval) _claude_code_plugin_eval ;;
        *) _claude_code_plugin ;;
      esac
    ' test "$1"
  }

  has_spec() {
    local -a parts
    parts=(${=1})
    specs_for "$parts[1]" | grep -F -- "$parts[2]["
  }

  root_commands() {
    zsh -f -c '
      _arguments() { state=command; }
      _describe() { print -rl -- "${commands[@]}"; }
      source completions/_claude >/dev/null
      _claude_code
    '
  }

  It 'offers purge among top-level commands'
    When call root_commands
    The output should include 'purge:'
    The status should be success
  End

  Describe 'listed options'
  Parameters
    'root --desktop'
    'configure --values-stdin'
    'install --marketplace'
    'list --data-size'
    'validate --profile'
    'eval --disallow-tools'
    'ultrareview --trust-workspace'
    'purge --dry-run'
    'restore-set-aside --discard'
  End

  It 'offers each option in its command context'
    When call has_spec "$1"
    The status should be success
    The output should be present
  End
  End
  It 'marks the data-size plugin argument as optional'
    When call specs_for list
    The output should include '--data-size[Measure saved plugin data (requires --json)]::plugin:'
  End

  It 'completes the documented validation profile'
    When call specs_for validate
    The output should include ':profile:(directory)'
  End

  It 'does not attach a value to the workspace trust flag'
    When call specs_for ultrareview
    The output should include '--trust-workspace[Trust the current folder for this run]'
    The output should not include '--trust-workspace[Trust the current folder for this run]:'
  End
End
