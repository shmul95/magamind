{ ... }: {
  flake.cabanashmul.homeModules.packages = { pkgs, lib, context, ... }: {
    home.packages = [
      (pkgs.writeShellApplication {
        name           = "build-profiles";
        runtimeInputs  = [ pkgs.coreutils pkgs.nix ];
        text           = builtins.readFile ../scripts/build-profiles.sh;
      })
      (pkgs.writeShellApplication {
        name           = "switch-profile";
        runtimeInputs  = [ pkgs.coreutils ];
        text           = builtins.readFile ../scripts/switch-profile.sh;
      })
    ] ++ lib.optionals (context == "desktop") (with pkgs; [ discord firefox kitty ]);
  };
}
