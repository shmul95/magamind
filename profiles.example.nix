# profiles.example.nix — copy to profiles.nix, edit, and commit to your fork
#
#   cp profiles.example.nix profiles.nix
#
# Switch profiles at build time:
#   CABANASHMUL_PROFILE=work home-manager switch --impure --flake .
{
  # "desktop" installs GUI apps (discord, firefox, kitty) and enables kitty config.
  # "server" or "wsl" skips all GUI packages.
  context = "desktop";

  defaultProfile = "personal";

  profiles = {
    personal = {
      git = {
        userName = "Your Name";
        userEmail = "you@personal.com";
      };
    };

    work = {
      git = {
        userName = "Your Work Name";
        userEmail = "you@company.com";
      };
    };
  };
}
