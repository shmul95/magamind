{ inputs, ... }: {
  flake.cabanashmul.homeModules.shmulvim = { ... }: {
    imports = [ inputs.shmulvim.homeManagerModules.default ];

    programs.shmulvim = {
      enable           = true;
      installPackage   = true;
      clipboard.provider = "auto";
    };
  };
}
