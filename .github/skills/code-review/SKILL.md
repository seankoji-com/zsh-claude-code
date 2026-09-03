---
name: code-review
description: Review priorities for zsh-claude-code pull requests — what deserves real scrutiny versus what to skip. Use for every PR review.
---

# Review priorities

Two files carry all the real logic: `zsh-claude-code.plugin.zsh` (fpath
wiring, deferred `compdef` registration, aliases) and `completions/_claude`
(an `_arguments`-based completion function mirroring the `claude` CLI's
subcommands and flags). Everything else is scaffolding around them.

## Spend real attention here

- `completions/_claude` wiring: every subcommand in the top-level
  `commands=(...)` array needs a matching `_claude_code_<name>` function
  reached from the `case $line[1]` dispatch under the `args` state, and
  vice versa. The file currently has one dangling case of this
  (`_claude_code_migrate_installer` is defined but never referenced) —
  don't assume existing wiring is clean, compare the diff against it.
- Short/long flag pairs written as `{-x,--xxx}` in `_arguments` blocks
  (`{-c,--continue}`, `{-r,--resume}`, `{-w,--worktree}`, etc.) must stay
  paired — adding one form without the other is a completion regression.
- Whether a changed flag's `_arguments` spec (takes a value? which
  literal choices?) agrees with its own one-line description in the
  `claude_opts` array a few lines above it — these are two hand-kept-in-
  sync definitions of the same flag set.
- `zsh-claude-code.plugin.zsh`'s `precmd`-deferral guard for `compdef`
  (it exists because a bare `compdef` before `compinit` silently no-ops).
  `spec/zsh-claude-code_spec.sh` tests this specifically; a PR that
  touches this logic without touching that spec deserves scrutiny.
- New completion logic in general: `spec/*.sh` covers fpath wiring, the
  defer hook, and the four aliases — it does not test individual
  `completions/_claude` subcommands, so a new or changed subcommand's
  correctness rests on review, not CI.

## Do not spend attention here

- `.github/workflows/*.yml` diffs from `chore(ci): sync caller templates
  from seankoji-com/.github` PRs — 3 of this repo's 5 PRs to date are
  exactly this bot sync; the content is authored in the
  `seankoji-com/.github` hub repo, not here.
- `README.md` / `LICENSE` — prose and license text, no logic.
- Shell formatting (quoting, indentation) with no lint config to violate
  — only flag it if it actually breaks under `zsh`, not as style.

## Comment style

- One comment per real issue, not one per file or line it repeats in.
- Before flagging a test gap, check `spec/zsh-claude-code_spec.sh` — it
  may already cover it.
