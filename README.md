# zsh-claude-code

Zsh completions and aliases for the [Claude Code](https://docs.claude.com/en/docs/claude-code) CLI.

The plugin adds a completion definition (`completions/_claude`) to your `fpath` and registers it for the `claude`, `claude-code`, and `cc` commands. Completions are autoloaded on the first Tab press rather than sourced at startup. If the plugin loads before `compinit`, the `compdef` registrations are deferred via a `precmd` hook and applied once `compinit` has run, so they are never silently dropped. Completion covers top-level flags (`--model`, `--permission-mode`, `--output-format`, `--resume`, etc.) and the `agents`, `auth`, `mcp`, `plugin`, `doctor`, `install`, `setup-token`, and `update` subcommands, including their own options. A handful of short aliases are also defined.

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

Tab completion is available for `claude`, `claude-code`, and `cc` once the plugin is loaded.

The following aliases are provided:

| Alias    | Expands to      |
|----------|-----------------|
| `cc`     | `claude`        |
| `ccc`    | `claude chat`   |
| `cca`    | `claude api`    |
| `cccfg`  | `claude config` |

## License

MIT — see [LICENSE](LICENSE).
