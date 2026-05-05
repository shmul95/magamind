#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_URL="${CABANASHMUL_TEMPLATE_URL:-https://github.com/shmul95/cabanashmul.git}"
TARGET_DIR="${1:-cabanashmul}"
PROFILE_PATH="profiles/personal.nix"
LOCAL_PATH="local.nix"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "setup: required command not found: $1" >&2
    exit 1
  fi
}

clone_repo() {
  if [ -e "$TARGET_DIR" ]; then
    echo "setup: target already exists: $TARGET_DIR" >&2
    echo "setup: pass a different directory name as the first argument if needed." >&2
    exit 1
  fi

  echo "Cloning template into: $TARGET_DIR"
  git clone "$TEMPLATE_URL" "$TARGET_DIR"
}

ensure_template_remote() {
  if git remote get-url template >/dev/null 2>&1; then
    return
  fi

  if git remote get-url origin >/dev/null 2>&1; then
    local origin_url
    origin_url="$(git remote get-url origin)"
    git remote rename origin template
    echo "Renamed remote 'origin' to 'template' ($origin_url)"
  else
    git remote add template "$TEMPLATE_URL"
    echo "Added remote 'template' -> $TEMPLATE_URL"
  fi
}

ensure_profile_file() {
  mkdir -p profiles
  if [ -e "$PROFILE_PATH" ]; then
    echo "Kept existing $PROFILE_PATH"
    return
  fi

  cp profiles/_example.nix.txt "$PROFILE_PATH"
  echo "Created $PROFILE_PATH"
}

ensure_local_file() {
  if [ -e "$LOCAL_PATH" ]; then
    echo "Kept existing $LOCAL_PATH"
    return
  fi

  cp local.example.nix "$LOCAL_PATH"
  echo "Created $LOCAL_PATH"
}

maybe_create_private_origin() {
  if git remote get-url origin >/dev/null 2>&1; then
    echo "Kept existing remote 'origin' -> $(git remote get-url origin)"
    return
  fi

  printf "Create a private GitHub repo and set it as origin? [y/N] "
  read -r reply
  case "$reply" in
    [yY]|[yY][eE][sS])
      need_cmd gh
      gh repo create "$(basename "$PWD")" --private --source=. --remote=origin --push
      echo "Created private GitHub repo and set remote 'origin'."
      ;;
    *)
      echo "Skipped GitHub repo creation."
      ;;
  esac
}

print_next_steps() {
  cat <<'EOF'

Next steps:
1. Edit profiles/personal.nix with your git identity and SSH key.
2. Edit local.nix if you want a different context or default profile.
3. Add modules under public/ or private/ if you want extra Home Manager config.
4. Commit your private changes:
   git add -f profiles/personal.nix local.nix
   git commit -m "personalize cabanashmul"
5. Rebuild:
   home-manager switch --impure --flake .

Future template updates:
  git fetch template
  git merge template/main
EOF
}

need_cmd git
clone_repo
cd "$TARGET_DIR"
ensure_template_remote
ensure_profile_file
ensure_local_file
maybe_create_private_origin
print_next_steps
