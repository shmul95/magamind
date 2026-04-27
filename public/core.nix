{ ... }: {
  flake.cabanashmul.homeModules.core = { lib, activeProfile, ... }: {
    programs.git = {
      enable   = true;
      settings = activeProfile.git.settings or {};
    };

    programs.ssh = lib.mkIf (activeProfile ? ssh) {
      enable              = true;
      enableDefaultConfig = false;
      matchBlocks         = activeProfile.ssh.matchBlocks or {};
    };
  };
}
