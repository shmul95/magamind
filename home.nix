{
  homeDirectory,
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    inputs.zshmul.homeManagerModules.default
    inputs.tshmux.homeManagerModules.default
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  # ======================================================================
  # WHO AM I?
  # `magamind` gets your username and home folder from the shell
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
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
      HYPHEN_INSENSITIVE = "true";
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
      # Put extra shell startup commands here.
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
    git
    neovim
  ];

  # ======================================================================
  # EXTRA ADVANCED STUFF
  # Keep this section for future tweaks that do not belong to zsh or tmux.
  # ======================================================================
}
