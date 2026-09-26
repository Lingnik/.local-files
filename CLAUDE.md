# ~/.local dotfiles

This repo IS `~/.local`. It is cloned in place, not symlinked into `$HOME`.
Every tool finds its config here through XDG variables and `ZDOTDIR`, which
are set system-wide in `/etc/zshenv`.

The repo is public. Nothing employer-specific, secret, or machine-specific
gets committed. See "Work layer" below.

## How it is wired

### /etc files (outside the repo, installed once per machine)

| System file     | Source in repo                  | Install method                          |
|-----------------|---------------------------------|-----------------------------------------|
| `/etc/zshenv`   | `config/zsh/global/zshenv`      | appended with `sudo tee -a`             |
| `/etc/zprofile` | `config/zsh/global/zprofile`    | replaces the macOS default              |
| `/etc/zshrc`    | `config/zsh/global/zshrc`       | replaces the macOS default              |

`global/zprofile` and `global/zshrc` are the stock macOS files plus the
timing header. `global/zshenv` is the one that matters: it exports

- `XDG_CONFIG_HOME=~/.local/config`, `XDG_DATA_HOME=~/.local/share`,
  `XDG_STATE_HOME=~/.local/state`, `XDG_CACHE_HOME=~/.local/cache`
- `ZDOTDIR=~/.local/config/zsh`, so zsh reads its user files from there
- `ZSH=~/.local/share/oh-my-zsh`, `ZSH_CUSTOM=~/.local/config/oh-my-zsh`
- `HISTFILE=~/.local/state/zsh/history` and the history options

Edits to `config/zsh/global/*` do nothing until they are copied into `/etc`
again. `/etc/zshenv` runs for every zsh process on the machine, including
root's scheduled jobs.

### zsh load order

```
/etc/zshenv -> $ZDOTDIR/.zshenv -> (oh-my-zsh, interactive only: $ZSH_CUSTOM/*.zsh)
/etc/zprofile -> $ZDOTDIR/.zprofile            (login shells)
/etc/zshrc -> $ZDOTDIR/.zshrc                  (interactive shells)
$ZDOTDIR/.zlogin, $ZDOTDIR/.zlogout            (login shells)
```

Almost everything lives in `config/zsh/.zshenv`, including PATH, pyenv,
oh-my-zsh, aliases and functions. `.zshrc` only re-runs `rbenv init` so its
shims win over the PATH that `/etc/zprofile`'s `path_helper` rebuilds.

`~/.zshenv` and `~/.zprofile` in `$HOME` are tripwires that print
"THIS FILE SHOULD NOT HAVE LOADED!". If that message appears, `ZDOTDIR` was
not set, which means `/etc/zshenv` is missing the global block.

### Timing header and log

Every zsh file starts and ends with a banner block that appends to
`~/log/zsh.log` and prints load time in milliseconds. It calls
`/opt/homebrew/bin/gdate`, so a machine needs `brew install coreutils` and a
`~/log` directory before the first shell starts. `grep file= ~/log/zsh.log`
shows which files loaded, in order, for each shell.

The block ends with `# DO NOT ADD MORE LINES`. Add new config above the
closing banner, not below it.

### Tools that read from here via XDG

| Tool      | Path in repo                         | Notes                                   |
|-----------|--------------------------------------|-----------------------------------------|
| git       | `config/git/config`, `config/git/ignore` | `~/.gitconfig` in `$HOME` also loads, and it wins. See below. |
| tmux      | `config/tmux/tmux.conf`              |                                         |
| neovim    | `config/nvim`                        | git submodule (`Lingnik/kickstart.nvim`). Commit and push inside it first, then commit the pointer here. |
| gh        | `config/gh/config.yml`               | `hosts.yml` (auth) is gitignored        |
| glow      | `config/glow/glow.yml`               |                                         |
| cursor    | `config/cursor/cli-config.json`      |                                         |
| oh-my-zsh | `config/oh-my-zsh/*.zsh`             | loaded as `ZSH_CUSTOM`                  |

### Apps that do not read XDG (manual import)

- **iTerm2**: `config/iterm2/iTermProfiles.json` (Settings > Profiles >
  Other Actions > Import JSON Profiles) and `config/iterm2/iTermKeys.itermkeymap`
  (Settings > Keys > Presets > Import).
- **BetterTouchTool**: `config/btt/Default.bttpreset` (Presets > Import).
  The license is not in the repo.

Re-export and commit after changing either app's settings.

### git identity

`config/git/config` sets the personal identity (GitHub noreply address).
`~/.gitconfig` lives outside the repo and holds per-directory `includeIf`
rules that pick an identity file by repo location. Git reads both, and
`~/.gitconfig` takes precedence. A repo outside every `includeIf` path uses
the identity from `config/git/config`.

## Work layer (gitignored)

`~/.local/work/` holds anything tied to a specific employer or machine.
It is listed in `.gitignore` and never committed. `.zshenv` loads it only
when present, so a machine without it starts cleanly:

- `work/bin/` is added to PATH
- `work/env` holds plain `export` lines and is also sourced by scripts in
  `bin/` (for example `backup-zsh-history`)
- `work/zshenv` holds shell functions and aliases, sourced at the end of
  `.zshenv`

Scripts in `bin/` read machine-specific values from environment variables
set in `work/env`, with generic defaults:

- `ZSH_HISTORY_ARCHIVE`: history archive for `hgrep` and `backup-zsh-history`
- `AWS_AZ_MAP_ROLES`: SSO role priority for `aws-az-map`

A work machine can also have a local pre-commit hook
(`.git/hooks/pre-commit`, not versioned) that rejects staged lines matching
employer names or work paths.

## Also gitignored

`/.secrets` (sourced by `.zshenv` if present), gh auth, shortcut-cli config,
homebrew and caddy runtime state, Python venvs, and tool-managed binaries or
symlinks in `bin/` (installed by brew, uv, or vendor installers).

## Adding something new

1. Tool supports XDG: put its config under `config/<tool>/`.
2. Script: `bin/` if generic, `work/bin/` if it names an employer, a work
   path, a work vault, or a work host.
3. Before committing, check the staged diff for employer names, work paths,
   email addresses, and tokens. The repo is public.

## Maintaining this doc

Update it when the wiring changes: a new `/etc` file, a new XDG tool, or a
new variable read from `work/env`.
