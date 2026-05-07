---
name: cabanashmul
created: 2026-04-17
last_updated: 2026-05-07
current_milestone: v1.1
current_milestone_name: GSD
status: planning
---

# cabanashmul

A dendritic Home Manager starter flake. Drop a `.nix` file in a folder and it loads.

## Core Value

A reproducible, modular Home Manager configuration that separates concerns into four independent layers (public base, optional private fork, per-identity profiles, optional secrets) and auto-imports each one. Users get a working Home Manager setup with one command, then evolve it by adding files — no central config to edit.

## What This Is

- **Template repo:** consumed via `nix run github:shmul95/cabanashmul#setup`
- **Pattern:** dendritic — every `*.nix` file in `public/`, `private/`, `profiles/` is auto-imported by `import-tree`
- **Identity model:** profiles drive per-user Git/SSH config; per-user flake outputs (`.#"$USER"-personal`, `.#"$USER"-work`)
- **Public/private split:** track shared defaults publicly, layer private modules and SSH-gated inputs without forking the public base
- **Tooling family:** integrates sibling repos `zshmul`, `tshmux`, `shmulvim`

## Stack

- Nix flakes (pinned via `flake.lock`)
- `flake-parts` — modular flake composition
- `import-tree` — filesystem-driven module discovery
- `home-manager` — user-level configuration
- `agenix` — encrypted secrets (opt-in)

Supported systems: `x86_64-linux`, `aarch64-linux` (no Darwin yet).

See `.planning/codebase/STACK.md` and `.planning/codebase/ARCHITECTURE.md` for full detail.

## Validated Requirements

### Layered config (validated v1.0)
- Public/private/profiles/secrets layers auto-import via `import-tree`
- Underscore-prefixed `_options.nix` / `_builder.nix` carry option schema and configuration builder

### Profile system (validated v0.2.0, refined v1.0)
- Per-user flake outputs: `.#"$USER"`, `.#"$USER"-<profile>`
- `defaultProfile` option resolves the bare `.#"$USER"` alias
- Per-profile Git identity wired via `core.nix`

### Secrets (validated v0.3.0)
- agenix-encrypted secrets via `secrets/` layer

### Onboarding (validated v1.0)
- `nix run github:shmul95/cabanashmul#setup` end-to-end bootstrap
- HTTPS template clone by default; `CABANASHMUL_TEMPLATE_URL` opt-in to SSH
- `template` remote established for upstream merges

### Profile switching ergonomics (validated v1.0)
- `build-profiles` — parallel prebuild of every profile
- `switch-profile <name>` — instant activation from prebuilt result link

## Active Requirements (v1.1 — see REQUIREMENTS.md)

See `.planning/REQUIREMENTS.md` for the full v1.1 requirement set.

## Current Milestone: v1.1 GSD

**Goal:** Wire `get-shmul-done` into cabanashmul as an opt-in module, ship script ergonomics (`switch-profile` flag passthrough, `update-cabanashmul` helper), and release v1.1.

**Target features:**
- `switch-profile` accepts and forwards Home Manager activation flags (`-b backup`, `-n` dry-run, `--show-trace`)
- `update-cabanashmul` script — fetch + merge `template/main`, rebuild profiles, optional switch
- Optional `public/gsd.nix` module exposing `cabanashmul.gsd.enable` (default `false`), wiring `inputs.get-shmul-done`
- README "Optional: AI runtimes via get-shmul-done" section
- CHANGELOG `v1.1.0` entry + git tag

**External prerequisite (not in this repo's scope):** `get-shmul-done` v1.0.0 must be tagged and public on GitHub before v1.1 ships. Audit, default `vault.path = null`, `init-vault` flake app, and URL flip to `github:` form happen in that repo.

## Out of Scope

- **get-shmul-done internals** — separate repo; cabanashmul only consumes it as a flake input.
- **`switch-profile -B` build-then-switch** — `build-profiles && switch-profile X` works; one knob is better than two.
- **Interactive prompts in `switch-profile`** — must stay scriptable (CI/non-interactive callers). Hints printed on first run are fine.
- **Darwin support** — out of scope for v1.1; tracked as a future requirement.

## Key Decisions

- **Dendritic pattern over central `home.nix`** — files-as-modules, no central registry. (v0.1.0)
- **HTTPS clone default in `setup`** — first-time users without SSH keys aren't blocked; SSH opt-in via env var. (v1.0)
- **Per-user flake outputs, not env vars** — `.#"$USER"-<profile>` is the documented form; `CABANASHMUL_PROFILE` deprecated. (v1.0)
- **Underscore-prefix for special files** — `_options.nix` / `_builder.nix` excluded by `import-tree` filter, listed explicitly in `flake.nix`.
- **`get-shmul-done` integration is opt-in** — default `cabanashmul.gsd.enable = false`; public users not forced to pull the dependency. (v1.1 plan)
- **`update-cabanashmul` ships in template** — setup app already establishes the `template` remote, so the assumption holds. Plain `git fetch` error is acceptable if a user removes the remote. (v1.1 plan)

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---

_Last updated: 2026-05-07 (milestone v1.1 GSD started)_
