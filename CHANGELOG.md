# Changelog

This project uses retroactive semantic version tags for major milestones in its history.

## 1.0.0 - 2026-05-05

First stable release. The structure (public / private / profiles / secrets layers, dendritic auto-import, profile-based identity) is considered stable and the onboarding path has been validated end-to-end.

- Rewrote the README with a clear pitch, architecture diagram, and a linear "Get Started" walkthrough that includes prerequisites, Nix install, bootstrap, apply, verify, and troubleshooting steps for users new to Nix and Home Manager.
- `setup` script now clones the template over HTTPS by default so first-time users without a configured GitHub SSH key are no longer blocked. The `CABANASHMUL_TEMPLATE_URL` env var still allows opting into SSH.
- Profile selection now uses per-user flake outputs (`.#"$USER"` for the default profile, `.#"$USER"-<profile>` for explicit selection); `CABANASHMUL_PROFILE` is deprecated but still honored for backward compatibility.
- Reorganized documentation per directory (`public/`, `private/`, `profiles/`, `secrets/`, `scripts/`) with each folder's README explaining its own role.
- Added `build-profiles` and `switch-profile` helpers for near-instant profile activation without re-evaluating the flake.
- Visual polish: centered hero block, badge row, and family footer linking sibling repos (`zshmul`, `tshmux`, `shmulvim`).

## 0.3.0 - 2026-04-27

- Added secrets support with `secrets/secrets.nix`.
- Established the base structure for managing secrets in the repo.

## 0.2.0 - 2026-04-22

- Added the profile system with per-profile Git identity.
- Introduced profile-driven configuration for different working contexts.

## 0.1.0 - 2026-04-17

- Bootstrapped the original starter flake.
- Established the initial Home Manager template structure for the project.
