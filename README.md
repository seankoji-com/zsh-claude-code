# zsh-claude-code

Zsh completions and aliases for the [Claude Code](https://docs.claude.com/en/docs/claude-code) CLI.

The plugin adds a completion definition (`completions/_claude`) to your `fpath` and registers it for the `claude` and `claude-code` commands. Completions are autoloaded on the first Tab press rather than sourced at startup. If the plugin loads before `compinit`, the `compdef` registrations are deferred via a `precmd` hook and applied once `compinit` has run, so they are never silently dropped. Completion covers the top-level flags and every subcommand that `claude --help` lists (background sessions, `auth`, `auto-mode`, `mcp`, `plugin`, `project`, `ultrareview` and the rest), including their own options. A weekly workflow compares the completions against the latest Claude Code release and opens an issue when they drift (see [Keeping completions current](#keeping-completions-current)).

## Installation

### Manual

Clone the repo and source the plugin from your `.zshrc`:

```zsh
git clone https://github.com/seankoji-com/zsh-claude-code ~/.zsh/zsh-claude-code
echo 'source ~/.zsh/zsh-claude-code/zsh-claude-code.plugin.zsh' >> ~/.zshrc
```

Make sure `compinit` is initialized in your `.zshrc` for completions to work:

```zsh
autoload -Uz compinit && compinit
```

### zinit

```zsh
zinit light seankoji-com/zsh-claude-code
```

### oh-my-zsh

Clone into your custom plugins directory:

```zsh
git clone https://github.com/seankoji-com/zsh-claude-code \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-claude-code
```

Then add it to the `plugins` array in your `.zshrc`:

```zsh
plugins=(... zsh-claude-code)
```

## Usage

Tab completion is available for `claude` and `claude-code` once the plugin is loaded. Aliases complete through their expansion.

| Alias | Expands to |
|-------|------------|
| `cld` | `claude`   |

`cc` is not aliased by default because it shadows the C compiler. To get it back:

```zsh
zstyle ':zsh-claude-code:aliases' cc yes   # before the plugin loads
```

## Keeping completions current

`scripts/completion-drift.sh` walks `claude --help` and every subcommand's `--help`, then lists flags and subcommands missing from `completions/_claude` and flags the completion file still offers that the CLI dropped:

```zsh
scripts/completion-drift.sh claude completions/_claude
```

It needs bash 4 or later. The `completion-drift` workflow runs it every Monday against the latest `@anthropic-ai/claude-code` from npm and opens or updates a single issue when it finds drift.

## License

MIT — see [LICENSE](LICENSE).
