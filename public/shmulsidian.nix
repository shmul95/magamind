{ self, inputs, ... }: {
  flake.cabanashmul.homeModules.shmulsidian = { ... }: {
    imports = [ inputs.shmulsidian.homeManagerModules.default ];

    programs.shmulsidian = {
      enable = true;

      # AI tools to wire the vault MCP + slash commands into.
      inherit (self.cabanashmul) providers;

      # Vault MCP enabled by default. Override per-profile to disable.
      mcp.enable = true;
    };
  };
}
