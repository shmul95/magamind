# magamind

`magamind` is a tiny Home Manager starter that sets up two things:

- `zshmul` for your shell
- `tshmux` for your tmux

The big idea is simple: you mostly change one file, [home.nix](./home.nix), and then Home Manager builds the rest.

## What lives here

- [flake.nix](./flake.nix): tells Nix which pieces to download
- [home.nix](./home.nix): the main file you edit

## Super Short Version

1. Get this repo on your computer.
2. Open [home.nix](./home.nix).
3. Read the big section titles and change what you want.
4. Run:

```bash
home-manager switch --impure --flake .
```

If you fork this repo to your own GitHub account and want to install from GitHub directly, use:

```bash
home-manager switch --impure --flake github:shmul95/magamind
```

If you want to start by cloning it locally:

```bash
git clone git@github.com:shmul95/magamind.git
cd magamind
home-manager switch --impure --flake .
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

## The First Things To Check

Open [home.nix](./home.nix) and look for these section titles:

- `WHO AM I?`
- `TURN ZSHMUL ON`
- `TURN TSHMUX ON`
- `ADD YOUR OWN PACKAGES`

### `WHO AM I?`

`magamind` takes your username and home folder from your shell environment when you run Home Manager with `--impure`.

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

## How To Rebuild

Every time you change [home.nix](./home.nix), run:

```bash
home-manager switch --impure --flake .
```

If the repo is on GitHub and you want to use it from anywhere:

```bash
home-manager switch --impure --flake github:shmul95/magamind
```

If you are still editing locally, stay with:

```bash
home-manager switch --impure --flake .
```

## If Something Breaks

Try these in order:

1. Run `home-manager build --impure --flake .` to check without switching.
2. Read the error message slowly. Nix errors are noisy, but they usually point to the bad option.
3. Undo the last small change you made in [home.nix](./home.nix).
4. Switch again.

If you are using the GitHub form, you can also test without switching:

```bash
home-manager build --impure --flake github:shmul95/magamind
```

If you already switched to something bad, you can roll back:

```bash
home-manager generations
home-manager switch --rollback
```

## Why The README Talks About Section Names

GitHub line links move around when files change. Big comment headers in [home.nix](./home.nix) are more stable, so this README points you to section names instead of fragile line numbers.
