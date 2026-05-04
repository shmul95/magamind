# cabanashmul

`cabanashmul` is a tiny Home Manager starter that sets up two things by default:

- `zshmul` for your shell
- `tshmux` for your tmux

It can also enable optional modules like `shmulcode`, `shmulistan`, and `shmulvim`.

The big idea is simple: you mostly change one file, [home.nix](./home.nix), and then Home Manager builds the rest.

## What lives here

- [flake.nix](./flake.nix): tells Nix which pieces to download
- [home.nix](./home.nix): the main file you edit
- [profiles/](./profiles): your per-profile identity files, such as `profiles/personal.nix`

## Super Short Version

1. Run the setup app:

```bash
nix run github:shmul95/cabanashmul#setup
```

2. This clones the template, renames the template remote to `template`, creates `profiles/personal.nix` and `local.nix` if missing, and optionally creates a private GitHub `origin`.
3. Edit `profiles/personal.nix`, `local.nix`, and [home.nix](./home.nix).
4. If `home-manager` is not installed yet, open a shell with it:

```bash
nix shell home-manager#home-manager
```

5. Rebuild:

```bash
home-manager switch --impure --flake .#"$USER"-personal
```

If you want to install this config directly from your private GitHub repo over SSH, use:

```bash
home-manager switch --impure --flake 'git+ssh://git@github.com/<you>/cabanashmul.git'
```

There is also a shorter flake-app form:

```bash
nix run 'git+ssh://git@github.com/<you>/cabanashmul.git'
```

That app exports `NIXPKGS_ALLOW_UNFREE=1` and runs:

```bash
home-manager switch --impure --flake '<this flake>'
```

You can also pass a target directory:

```bash
nix run github:shmul95/cabanashmul#setup -- my-dotfiles
```

## Non-NixOS: make zsh your default login shell

On non-NixOS systems, Home Manager configures `zsh`, but it does not change your system login shell by itself.

After `home-manager switch`, run:

```bash
ZSH_PATH="$(command -v zsh)"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
chsh -s "$ZSH_PATH"
```

Then log out and log back in.

To verify:

```bash
echo "$SHELL"
getent passwd "$USER" | cut -d: -f7
```

## Profiles — identity per context

`cabanashmul` loads your git identity from files in [profiles/](./profiles), for example `profiles/personal.nix` or `profiles/work.nix`. These files are meant to live in your private repo, not in the public template.

**Setup:**

```bash
nix run github:shmul95/cabanashmul#setup
# Edit profiles/personal.nix with your real name, email, and SSH key
# Edit local.nix if you want a different context or default profile
git add -f profiles/personal.nix local.nix home.nix
git commit -m "add personal profile"
home-manager switch --impure --flake .#"$USER"-personal
```

**Switching profiles at build time:**

```bash
CABANASHMUL_PROFILE=work home-manager switch --impure --flake .
CABANASHMUL_PROFILE=personal home-manager switch --impure --flake .
```

If no env var is set, `defaultProfile` from `local.nix` is used.

**Desktop vs server:**

Set `context = "desktop"` in `local.nix` to get GUI packages (`discord`, `firefox`, `kitty`). Set `context = "server"` or `context = "wsl"` to skip them.

## Fast profile switching

Once you've added files under `profiles/`, you can pre-build all of them and switch between them without Nix evaluation or rebuilding. This is useful if you have multiple contexts (personal, work) that you switch between often.

**First time setup:**

```bash
cd /path/to/cabanashmul
build-profiles
```

This builds all profiles defined under `profiles/` and stores the results at `$XDG_DATA_HOME/cabanashmul/result-<profile>` (defaults to `~/.local/share/cabanashmul/result-<profile>`).

**Switching profiles:**

```bash
switch-profile personal
switch-profile work
```

Each switch activates the pre-built result instantly, with zero Nix evaluation.

**The `build-profiles` command:**

- Reads all profiles from `profiles/`
- Rebuilds each one (takes time)
- Stores result symlinks at `$XDG_DATA_HOME/cabanashmul/result-<profile>`
- Can be run from the repo directory or from anywhere if `CABANASHMUL_DIR` is set

**If you change your config:**

After editing [home.nix](./home.nix), files under [profiles/](./profiles), or `local.nix`, run `build-profiles` again to update the pre-built results.

**The traditional workflow still works:**

If you prefer the original approach, you can still use:

```bash
CABANASHMUL_PROFILE=work home-manager switch --impure --flake .
```

Both approaches coexist. Use `build-profiles` + `switch-profile` for speed when you switch often, or use the env var approach if you rebuild less frequently.

## The First Things To Check

Open [home.nix](./home.nix) and look for these section titles:

- `WHO AM I?`
- `TURN ZSHMUL ON`
- `TURN TSHMUX ON`
- `ADD YOUR OWN PACKAGES`
- `OPTIONAL MODULES`

### `WHO AM I?`

`cabanashmul` takes your username and home folder from your shell environment when you run Home Manager with `--impure`.

If it guesses wrong, edit the values near the top of [home.nix](./home.nix):

- `username`
- `homeDirectory`

If it guesses right, you do not need to touch this part.

### `TURN ZSHMUL ON`

This section changes your shell.

Things you can change there:

- `autoStartTshmux`: start tmux automatically when you open a shell
- `aliases`: small shortcut commands like `l`
- `extraPackages`: tools you want in your shell
- `sessionVariables`: environment variables
- `prompt.*`: prompt shape and symbols
- `ohMyZshPlugins`: extra Zsh plugins
- `extraInitContent`: raw shell lines for custom tricks

### `TURN TSHMUX ON`

This section changes tmux.

Things you can change there:

- `setAsDefaultTmux`: make `tmux` use the tshmux wrapper
- `enableMouse`: mouse on or off
- `enableViCopyMode`: vi-style copy mode on or off
- `enableSessionRestore`: restore tmux sessions automatically
- `clipboard.enable`: copy yanks to your system clipboard
- `status.position`: top or bottom
- `status.left` and `status.right`: text on the tmux bar
- `theme.*`: colors
- `extraConfig`: raw tmux commands for custom tricks

## A Tiny Example

If you want a different shell prompt sign and the tmux bar at the bottom:

```nix
programs.zshmul.prompt.symbol = ">";
programs.tshmux.status.position = "bottom";
```

## Optional Modules

`cabanashmul` can also wire in optional modules from other repos.

### What `shmulcode` pulls by default here

If you leave the `shmulcode` block in [home.nix](./home.nix) as-is, it will:

- install the `claude-code` package
- install Claude shell integration
- write `~/.claude/CLAUDE.md` and `~/.claude/settings.json`
- pull all discovered agents from `shmulcode/agents/`
- pull all discovered skills from `shmulcode/skills/`
- pull all discovered commands from `shmulcode/commands/` if that repo has any
- enable vault integration and clone `shmulistan` to `~/shmulistan` if it is missing
- install `obsidian` because `programs.claude.vault.enable = true`

In the current local `shmulcode` repo, that means all agents and these skills are enabled by default:

- `deterministic-llm-architecture`
- `git-worktrees`
- `k8s-nix-deployment`
- `n8n`
- `nix-flake-parts`
- `skill-creator`
- `supabase`
- `systematic-debugging`

`qrouter` is not enabled in this starter unless you turn it on explicitly.

### What `shmulistan` pulls by default here

If you leave the `shmulistan` block in [home.nix](./home.nix) as-is, it will:

- install the `shmulistan` package
- install `pnpm_9`
- create the standard vault folder structure under `~/shmulistan`

That module is small. Its main knobs are just:

- `programs.shmulistan.enable`
- `programs.shmulistan.vaultPath`

### Make `shmulcode` atomic

The `shmulcode` module is already split into independent categories. In [home.nix](./home.nix), the block is written so you can toggle these separately:

- `programs.claude.enable`
- `programs.claude.agents.enable`
- `programs.claude.skills.enable`
- `programs.claude.commands.enable`
- `programs.claude.vault.enable`
- `programs.claude.qrouter.enable`

You can also disable specific discovered items one by one:

```nix
programs.claude.skills.enabled."git-worktrees" = false;
programs.claude.agents.enabled."finance-specialist" = false;
```

### Example: pull only skills from `shmulcode`

Use this shape in [home.nix](./home.nix):

```nix
programs.claude = lib.mkIf (inputs ? shmulcode) {
  enable = true;

  agents.enable = false;
  skills.enable = true;
  commands.enable = false;

  # Disable vault integration if you only want the Claude skills.
  vault.enable = false;

  qrouter.enable = false;
};
```

### Example: pull only one skill

```nix
programs.claude = lib.mkIf (inputs ? shmulcode) {
  enable = true;

  agents.enable = false;
  skills.enable = true;
  commands.enable = false;
  vault.enable = false;
  qrouter.enable = false;

  skills.enabled = {
    deterministic-llm-architecture = false;
    git-worktrees = true;
    k8s-nix-deployment = false;
    n8n = false;
    nix-flake-parts = false;
    skill-creator = false;
    supabase = false;
    systematic-debugging = false;
  };
};
```

## Using cabanashmul from a NixOS flake

`cabanashmul` exposes a `homeManagerModules.default` output so NixOS configs can consume it directly:

```nix
# In your NixOS flake.nix inputs:
cabanashmul.url = "github:shmul95/cabanashmul";

# In your home-manager config:
imports = [ inputs.cabanashmul.homeManagerModules.default ];
```

The consuming flake must pass `activeProfile`, `context`, `username`, and `homeDirectory` via `extraSpecialArgs`. It can override `home.username`, `home.homeDirectory`, and `home.stateVersion` since they are set with `lib.mkDefault`.

## How To Rebuild

Every time you change [home.nix](./home.nix), run:

```bash
home-manager switch --impure --flake .#"$USER"-personal
```

If the repo is on GitHub and you want to use it from anywhere:

```bash
home-manager switch --impure --flake 'git+ssh://git@github.com/<you>/cabanashmul.git'
```

If you are still editing locally, stay with:

```bash
home-manager switch --impure --flake .#"$USER"-personal
```

## If Something Breaks

Try these in order:

1. Run `home-manager build --impure --flake .` to check without switching.
2. Read the error message slowly. Nix errors are noisy, but they usually point to the bad option.
3. Undo the last small change you made in [home.nix](./home.nix).
4. Switch again.

If you are using the GitHub form, you can also test without switching:

```bash
home-manager build --impure --flake github:shmul95/cabanashmul
```

If you already switched to something bad, you can roll back:

```bash
home-manager generations
home-manager switch --rollback
```

## Why The README Talks About Section Names

GitHub line links move around when files change. Big comment headers in [home.nix](./home.nix) are more stable, so this README points you to section names instead of fragile line numbers.
