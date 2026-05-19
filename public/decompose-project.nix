{ inputs, ... }: {
  # cabanashmul.decompose-project — opt-in home-manager module installing the
  # /decompose-project and /create-service Claude Code skills.
  #
  # Source: github.com/cabanashmul/decompose-project
  #
  # Usage in a profile:
  #   cabanashmul.decompose-project.enable = true;
  #
  # This drops the two SKILL.md files into ~/.claude/skills/, making the
  # `/decompose-project` and `/create-service` commands available in any
  # Claude Code session.

  flake.cabanashmul.homeModules.decompose-project = { lib, config, ... }:
    let
      cfg = config.cabanashmul.decompose-project;
      src = inputs.decompose-project;
    in {
      options.cabanashmul.decompose-project = {
        enable = lib.mkEnableOption
          "claude skills for bootstrapping multi-repo projects (/decompose-project and /create-service)";
      };

      config = lib.mkIf cfg.enable {
        home.file.".claude/skills/decompose-project/SKILL.md".source =
          "${src}/skills/decompose-project/SKILL.md";
        home.file.".claude/skills/create-service/SKILL.md".source =
          "${src}/skills/create-service/SKILL.md";
      };
    };
}
