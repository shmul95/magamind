# Copy to local.nix (gitignored) and edit.
# Declares the machine context and which profile is active by default.
{ ... }: {
  flake.cabanashmul.context        = "server";   # "server" | "wsl" | "desktop"
  flake.cabanashmul.defaultProfile = "personal"; # must match a file in profiles/
}
