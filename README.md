# cabanashmul

A dendritic Home Manager starter flake. Drop a `.nix` file in a folder, and it loads.

Most Home Manager repos grow into a tangled `home.nix` that mixes machine setup, identity, and secrets. `cabanashmul` separates those concerns into four independent layers — a public base, an optional private fork, per-identity profiles, and optional secrets — and auto-imports each one. There is no central file to edit.

## Highlights

- **Dendritic layout** — every `*.nix` file in `public/`, `private/`, and `profiles/` is auto-imported via [`import-tree`](https://github.com/vic/import-tree). Adding a module is creating a file.
- **Public / private split** — track shared defaults publicly, layer private modules and `git+ssh` flake inputs on top without forking the public base.
- **Profiles as identity** — switch Git and SSH identity per profile (`personal`, `work`, ...) with `CABANASHMUL_PROFILE=work home-manager switch ...` or per-user flake outputs.
- **One-command bootstrap** — `nix run github:shmul95/cabanashmul#setup` creates `profiles/personal.nix` and `local.nix` for you.
- **Optional agenix** — secrets, private modules, and extra profiles are all opt-in. The starter works with just `profiles/personal.nix`.

## Architecture

```
cabanashmul/
├── public/        # tracked base modules (auto-imported)
│   ├── _options.nix    # flake.cabanashmul option schema
│   ├── _builder.nix    # builds homeConfigurations, picks active profile
│   ├── core.nix        # git + ssh wiring from the active profile
│   ├── zshmul.nix · tshmux.nix · shmulvim.nix · kitty.nix · ...
│   └── packages.nix
├── private/       # optional, .gitignored: private modules + SSH-gated inputs
├── profiles/      # per-identity Git/SSH settings (personal.nix, work.nix, ...)
├── secrets/       # optional agenix recipient map
├── local.nix      # machine-local defaults (context, defaultProfile)
└── flake.nix
```

Profile selection order: `CABANASHMUL_PROFILE` → `flake.cabanashmul.defaultProfile` → `personal` → the only profile.

## Quick Start

```bash
nix run github:shmul95/cabanashmul#setup     # bootstrap profiles/personal.nix + local.nix
nix shell home-manager#home-manager          # if home-manager isn't installed
home-manager switch --impure --flake .
```

The setup app creates `profiles/personal.nix` and `local.nix`. After that, `home-manager switch --impure --flake .` builds your default profile. Pass `CABANASHMUL_PROFILE=...` or use `.#"$USER"-<profile>` to pick a different one.

## New To Nix? Start Here

If you've never used Nix or Home Manager, this section gets you from zero to a working setup. Skip it if you already have Nix with flakes enabled.

**1. What you're about to install**

- **Nix** — a package manager that installs software in `/nix/store` without touching your system. Reproducible, removable, parallel versions.
- **Home Manager** — a Nix tool that manages your user-level dotfiles and packages declaratively. Instead of editing `~/.zshrc` by hand, you describe what you want in a `.nix` file and rebuild.
- **cabanashmul** — a starter template that gives Home Manager a sensible folder structure so you don't have to design one yourself.

You don't need to learn the Nix language to use this. You'll mostly be copying files and editing values.

**2. Install Nix**

The Determinate Systems installer is the easiest path. It enables flakes by default and is cleanly uninstallable:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Then open a new terminal so `nix` is on your `PATH`.

If you used another installer and `nix run` complains about flakes, add this to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

**3. Bootstrap your config**

Pick a directory you want to keep your config in (for example `~/cabanashmul`), `cd` into it, then:

```bash
nix run github:shmul95/cabanashmul#setup
```

This creates `profiles/personal.nix` and `local.nix` in the current directory. Open `profiles/personal.nix` and put your real name and email in the `git.settings.user` block.

**4. Apply it**

```bash
nix shell home-manager#home-manager       # only needed the first time
home-manager switch --impure --flake .
```

That's it — your shell, tmux, editor, and packages are now managed by this flake.

**5. Daily loop**

Edit a file, then re-run:

```bash
home-manager switch --impure --flake .
```

To roll back a bad change: `home-manager generations` then `/nix/var/nix/profiles/per-user/$USER/home-manager-<N>-link/activate`.

If something looks unfamiliar, the [Home Manager manual](https://nix-community.github.io/home-manager/) and [nix.dev](https://nix.dev/) are the canonical references.

## How To Customize It

Most changes happen in [`public/`](./public/README.md).

- Want to change shell behavior? Edit [`public/zshmul.nix`](./public/zshmul.nix).
- Want to change tmux behavior? Edit [`public/tshmux.nix`](./public/tshmux.nix).
- Want to change the installed packages? Edit [`public/packages.nix`](./public/packages.nix).
- Do not want `shmulvim`? Delete [`public/shmulvim.nix`](./public/shmulvim.nix) in your fork.
- Want to add another public module? Add a new `*.nix` file in `public/`.

If the change belongs in the template, keep it in `public/`.

If the change is only for your private fork, put it in `private/`.

If a private module depends on a private repository, add that repository as a `git+ssh` flake input in [`flake.nix`](./flake.nix), then import it from `private/`. Official flake input docs:

- https://nix.dev/concepts/flakes.html
- https://nix.dev/manual/nix/stable/command-ref/new-cli/nix3-flake.html

For local machine defaults, copy [`local.example.nix`](./local.example.nix) to `local.nix` if `setup` did not already create it:

```nix
{ ... }: {
  flake.cabanashmul.context = "server";
}
```

## Directory Guide

- [`public/`](./public/README.md): public modules, load order, and the defaults this template ships with
- [`private/`](./private/README.md): private-only modules and `git+ssh` input pattern
- [`profiles/`](./profiles/README.md): default `personal` profile, extra profiles, and how profile selection works
- [`scripts/`](./scripts/README.md): setup, prebuild, and fast profile-switching helpers
- [`secrets/`](./secrets/README.md): optional agenix recipient map and how it connects to profiles

## What Is Optional

- Staying with only `profiles/personal.nix` is fine. Extra profiles are optional.
- `private/` is optional. Use it only for private modules or private inputs.
- `secrets/` is optional. Plain values and normal `~/.ssh/...` paths are still valid.

## Non-NixOS Shell Setup

Home Manager can install `zsh`, but it does not change your system login shell by itself.

After `home-manager switch`, run:

```bash
ZSH_PATH="$(command -v zsh)"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
chsh -s "$ZSH_PATH"
```

Then log out and log back in.

## Updating From The Template

If your repo was created with the setup app, the public template remote is named `template`.

```bash
git fetch template
git merge template/main
```
