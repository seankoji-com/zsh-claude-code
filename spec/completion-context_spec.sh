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
        eval) _claude_code_plugin_eval ;;
        *) _claude_code_plugin ;;
      esac
    ' test "$1"
  }

  has_spec() {
    local -a parts
    parts=(${=1})
    specs_for "$parts[1]" | grep -F -- "$parts[2]"
  }

  Parameters
    'root --desktop'
    'configure --values-stdin'
    'install --marketplace'
    'list --data-size'
    'validate --profile'
    'eval --disallow-tools'
    'ultrareview --trust-workspace'
    'restore-set-aside --discard'
  End

  It 'offers each option in its command context'
    When call has_spec "$1"
    The status should be success
    The output should be present
  End
End
