{ ... }: {
  flake.cabanashmul.homeModules.direnv = { ... }: {
    programs.direnv = {
      enable       = true;
      nix-direnv.enable = true;
    };
  };
}
