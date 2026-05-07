---
project: cabanashmul
last_updated: 2026-05-07
---

# Milestones

Retroactive milestone log. v0.x series predates GSD adoption — entries summarized from `CHANGELOG.md` and git history.

## v1.0 — First Stable Release · 2026-05-05

**Status:** ✅ Shipped (git tag `1.0.0`, commit `0a1131d`)

**Goal:** Declare the four-layer structure (public / private / profiles / secrets) and dendritic auto-import stable. Validate the onboarding path end-to-end.

**Shipped:**
- README rewrite with clear pitch, architecture diagram, and linear "Get Started" walkthrough
- `setup` script HTTPS-by-default (SSH opt-in via `CABANASHMUL_TEMPLATE_URL`)
- Per-user flake output profile selection (`.#"$USER"-<profile>`); `CABANASHMUL_PROFILE` deprecated
- Per-directory READMEs (`public/`, `private/`, `profiles/`, `secrets/`, `scripts/`)
- `build-profiles` and `switch-profile` helpers for instant profile activation
- Visual polish: hero block, badge row, family footer

**Predecessor tags (v0.x):** `0.1.0` bootstrap (2026-04-17) → `0.2.0` profile system (2026-04-22) → `0.3.0` secrets support (2026-04-27) → patch tags through `0.4.0`.

**Note:** v1.0 shipped before GSD planning was adopted. This entry is retroactive.

---

## v1.1 — GSD · in progress

**Status:** 🟡 Planning

**Goal:** Wire `get-shmul-done` into cabanashmul as an opt-in module, ship script ergonomics, release v1.1.

See `.planning/REQUIREMENTS.md` and `.planning/ROADMAP.md` for the active scope.
