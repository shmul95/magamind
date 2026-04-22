{
  activeProfile,
  context,
  homeDirectory,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
let
  isDesktop = context == "desktop";
  desktopPkgs = with pkgs; [
    discord
    firefox
    kitty
  ];
in
{
  imports = [
    inputs.zshmul.homeManagerModules.default
    inputs.tshmux.homeManagerModules.default
  ]
  ++ lib.optionals (inputs ? shmulvim)    [ inputs.shmulvim.homeManagerModules.default ]
  ++ lib.optionals (inputs ? shmulcode)   [ inputs.shmulcode.homeManagerModules.default ]
  ++ lib.optionals (inputs ? shmulistan)  [ inputs.shmulistan.homeManagerModules.default ]
  ++ lib.optionals (inputs ? shmulex)     [ inputs.shmulex.homeManagerModules.default ];

  home = {
    username = lib.mkDefault username;
    homeDirectory = lib.mkDefault homeDirectory;
    stateVersion = lib.mkDefault "25.05";
  };

  programs.home-manager.enable = true;

  # ======================================================================
  # GIT — identity configured from your active profile (see profiles.nix)
  # ======================================================================
  programs.git = {
    enable = true;
    userName = activeProfile.git.userName;
    userEmail = activeProfile.git.userEmail;
  };

  # ======================================================================
  # SSH — per-profile match blocks (identity files, hosts, options)
  # Add an `ssh.matchBlocks` attrset to your profile to activate this.
  # ======================================================================
  programs.ssh = lib.mkIf (activeProfile ? ssh) {
    enable = true;
    matchBlocks = activeProfile.ssh.matchBlocks or {};
  };

  # ======================================================================
  # WHO AM I?
  # `cabanashmul` gets your username and home folder from the shell
  # environment when you run `home-manager ... --impure`.
  # ======================================================================

  # ======================================================================
  # TURN ZSHMUL ON
  # This section controls your shell.
  # You can change aliases, add packages, and tweak the prompt here.
  # ======================================================================
  programs.zshmul = {
    enable = true;
    installPackage = true;
    autoStartTshmux = true;

    aliases = {
      l = "ls -la";
      lg = "lazygit";
      nd = "nix develop";
    };

    extraPackages = with pkgs; [
      lazygit
      bat
      tree
      xclip
      wl-clipboard
      ripgrep
      fd
      gh
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
      HYPHEN_INSENSITIVE = "true";
      SHELL = "${pkgs.zsh}/bin/zsh";
    };

    prompt = {
      layout = "singleline";
      symbol = "$";
      arrowSymbol = "->";
      relativePath = "adaptive";
      cursor = "terminal";
    };

    ohMyZshPlugins = [
      "git"
      "z"
    ];

    extraInitContent = ''
      # Load nvm in zsh sessions (manual ~/.nvm install).
      export NVM_DIR="$HOME/.nvm"
      if [ -s "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
      fi
      if [ -s "$NVM_DIR/bash_completion" ]; then
        . "$NVM_DIR/bash_completion"
      fi
    '';
  };

  # ======================================================================
  # TURN TSHMUX ON
  # This section controls your tmux setup.
  # You can change the bar position, colors, mouse mode, and more here.
  # ======================================================================
  programs.tshmux = {
    enable = true;
    installPackage = true;
    setAsDefaultTmux = true;
    enableShellIntegration = true;
    enableMouse = true;
    enableViCopyMode = true;
    enableSessionRestore = true;

    clipboard.enable = true;

    status.position = "top";
    status.left = "#[fg=#{@color-yellow},bold]\\[#S\\]#[fg=#{@color-gray-light},bold] | ";
    status.right = "";

    theme = {
      yellow = "#FFDF32";
      black = "#000000";
      grayLight = "#D8DEE9";
      grayMedium = "#ABB2BF";
      grayDark = "#3B4252";
    };

    extraConfig = ''
      # Put extra tmux commands here.
    '';
  };

  # ======================================================================
  # ADD YOUR OWN PACKAGES
  # If you want more apps available everywhere, put them here.
  # ======================================================================
  home.packages = with pkgs; [
    neovim
  ] ++ lib.optionals isDesktop desktopPkgs;

  # ======================================================================
  # OPTIONAL MODULES
  # Uncomment the matching input in flake.nix to activate these.
  # ======================================================================

  # programs.shmulvim   = lib.mkIf (inputs ? shmulvim)   { enable = true; };
  programs.claude = lib.mkIf (inputs ? shmulcode) {
    enable = true;

    # `shmulcode` is atomic: each category can be toggled independently.
    agents.enable = true;
    skills.enable = true;
    commands.enable = true;

    # Vault integration is separate from the `shmulistan` Home Manager module.
    vault = {
      enable = true;
      repoUrl = "git+ssh://git@github.com/shmul95/shmulistan";
    };

    qrouter.enable = false;
  };

  programs.shmulistan = lib.mkIf (inputs ? shmulistan) {
    enable = true;
  };

  # ======================================================================
  # SHMULEX (optional) — uncomment input in flake.nix to activate
  # ======================================================================
  shmulex = lib.mkIf (inputs ? shmulex) {
    enable = true;
    source = inputs.shmulcode;

    roles.enable = true;
    codexAgents.enable = false;

    claudeMcp.enable = false;
    claudeCommands.enable = false;
    claudeRoutingPolicy.enable = false;
  };

  # ======================================================================
  # DESKTOP — kitty terminal, only active when context = "desktop"
  # ======================================================================
  programs.kitty = lib.mkIf isDesktop {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      disable_ligatures = "never";
    };
  };

  # ======================================================================
  # DIRENV — auto-load nix dev shells when you cd into a project
  # Pairs with nix-direnv for fast, cached shell activation.
  # ======================================================================
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ======================================================================
  # EXTRA ADVANCED STUFF
  # Keep this section for future tweaks that do not belong to zsh or tmux.
  # ======================================================================
}
