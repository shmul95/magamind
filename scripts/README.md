# scripts

This directory contains the shell helpers used by the flake and installed commands.

## Files

- [`setup.sh`](./setup.sh): bootstrap a new repo from the template
- [`build-profiles.sh`](./build-profiles.sh): prebuild every discovered profile
- [`switch-profile.sh`](./switch-profile.sh): activate a prebuilt profile result instantly

## Setup Workflow

[`setup.sh`](./setup.sh) is exposed as:

```bash
nix run github:shmul95/cabanashmul#setup
```

It:

- clones the template
- renames `origin` to `template`
- creates `profiles/personal.nix` if missing
- creates `local.nix` if missing
- optionally creates a private GitHub `origin`

## Fast Profile Switching

[`build-profiles.sh`](./build-profiles.sh) is installed as `build-profiles`.

It:

- reads available profile names from `flake.lib.profileNamesStr`
- builds `homeConfigurations.<user>-<profile>.activationPackage`
- stores symlinks under `$XDG_DATA_HOME/cabanashmul/result-<profile>`

Run:

```bash
build-profiles
```

[`switch-profile.sh`](./switch-profile.sh) is installed as `switch-profile`.

Run:

```bash
switch-profile personal
```

That executes the saved activation result directly, without another Nix evaluation.
