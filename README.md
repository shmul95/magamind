# cabanashmul

`cabanashmul` is a Home Manager starter flake built around small modules, profile-based identity, and an optional private layer for SSH-gated repos and local-only config.

The flake loads:

- tracked modules from [`public/`](./public/README.md)
- optional private modules from [`private/`](./private/README.md)
- per-identity profile files from [`profiles/`](./profiles/README.md)
- machine-local defaults from [`local.example.nix`](./local.example.nix) copied to `local.nix`

There is no central `home.nix`. You extend the setup by adding modules and profile files.

## Quick Start

Bootstrap a repo:

```bash
nix run github:shmul95/cabanashmul#setup
```

If `home-manager` is not installed yet:

```bash
nix shell home-manager#home-manager
```

Then rebuild:

```bash
home-manager switch --impure --flake .
```

For local machine defaults, copy [`local.example.nix`](./local.example.nix) to `local.nix`:

```nix
{ ... }: {
  flake.cabanashmul.context = "server";
  flake.cabanashmul.defaultProfile = "personal";
}
```

## Directory Guide

- [`public/`](./public/README.md): public modules, load order, and the defaults this template ships with
- [`private/`](./private/README.md): private-only modules and `git+ssh` input pattern
- [`profiles/`](./profiles/README.md): per-profile identity files and how profile selection works
- [`scripts/`](./scripts/README.md): setup, prebuild, and fast profile-switching helpers
- [`secrets/`](./secrets/README.md): agenix recipient map and how it connects to profiles

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
