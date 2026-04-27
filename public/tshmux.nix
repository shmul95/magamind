{ inputs, ... }: {
  flake.cabanashmul.homeModules.tshmux = { ... }: {
    imports = [ inputs.tshmux.homeManagerModules.default ];

    programs.tshmux = {
      enable               = true;
      installPackage       = true;
      setAsDefaultTmux     = true;
      enableShellIntegration = true;
      enableMouse          = true;
      enableViCopyMode     = true;
      enableSessionRestore = true;

      clipboard.enable = true;

      status.position = "top";
      status.left     = "#[fg=#{@color-yellow},bold]\\[#S\\]#[fg=#{@color-gray-light},bold] | ";
      status.right    = "";

      theme = {
        yellow     = "#FFDF32";
        black      = "#000000";
        grayLight  = "#D8DEE9";
        grayMedium = "#ABB2BF";
        grayDark   = "#3B4252";
      };

      extraConfig = ''
        # Put extra tmux commands here.
      '';
    };
  };
}
