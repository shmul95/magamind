{
  description = "cabanashmul - a tiny Home Manager starter for zshmul and tshmux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zshmul = {
      url = "github:shmul95/zshmul";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tshmux = {
      url = "github:shmul95/tshmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional — uncomment to enable
    # shmulvim = {
    #   url = "github:shmul95/shmulvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    shmulcode = {
      url = "git+ssh://git@github.com/shmul95/shmulcode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    shmulistan = {
      url = "git+ssh://git@github.com/shmul95/shmulistan";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional — uncomment to enable
    # shmulex = {
    #   url = "git+ssh://git@github.com/shmul95/shmulex";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, home-manager, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system =
        if builtins ? currentSystem then builtins.currentSystem else "x86_64-linux";
      username =
        let detected = builtins.getEnv "USER";
        in if detected != "" then detected else "your-username";
      homeDirectory =
        let detected = builtins.getEnv "HOME";
        in if detected != "" then detected else "/home/${username}";
      hostname = builtins.getEnv "HOSTNAME";

      # ── Profile loading ──────────────────────────────────────────────
      # profiles.nix is tracked in your private fork.
      # Copy profiles.example.nix → profiles.nix, edit, and commit.
      profilesCfg =
        if builtins.pathExists ./profiles.nix
        then import ./profiles.nix
        else {
          context = "server";
          defaultProfile = "default";
          profiles.default = {
            git = {
              userName = "Git User";
              userEmail = "user@example.com";
            };
          };
        };
      profileEnv = builtins.getEnv "CABANASHMUL_PROFILE";
      activeProfileName =
        if profileEnv != "" then profileEnv
        else profilesCfg.defaultProfile;
      activeProfile =
        if profilesCfg.profiles ? ${activeProfileName}
        then profilesCfg.profiles.${activeProfileName}
        else builtins.throw
          "cabanashmul: profile '${activeProfileName}' not found. Available: ${builtins.concatStringsSep ", " (builtins.attrNames profilesCfg.profiles)}";
      context = profilesCfg.context or "server";

      pkgs = import nixpkgs { inherit system; };
      homeConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit homeDirectory inputs username activeProfile context;
        };
        modules = [ ./home.nix ];
      };
      configNames =
        [
          { name = "default"; value = homeConfig; }
          { name = username; value = homeConfig; }
        ]
        ++ lib.optional (hostname != "") {
          name = "${username}@${hostname}";
          value = homeConfig;
        };
    in {
      homeConfigurations = builtins.listToAttrs configNames;

      # Reusable module for consuming flakes (e.g. shmulOS).
      # The consuming flake must pass activeProfile, context, username,
      # and homeDirectory via extraSpecialArgs.
      homeManagerModules.default = import ./home.nix;

      # Helper for thin consumer repos (e.g. my-cabanashmul).
      # Usage:
      #   homeConfigurations.default = cabanashmul.lib.mkHomeConfig {
      #     profiles = import ./profiles.nix;
      #   };
      lib.mkHomeConfig = {
        profiles,
        extraModules ? [],
        extraSpecialArgs ? {},
      }:
        let
          profEnv = builtins.getEnv "CABANASHMUL_PROFILE";
          activeProfileName =
            if profEnv != "" then profEnv
            else profiles.defaultProfile;
          callerProfile =
            if profiles.profiles ? ${activeProfileName}
            then profiles.profiles.${activeProfileName}
            else builtins.throw
              "cabanashmul: profile '${activeProfileName}' not found. Available: ${builtins.concatStringsSep ", " (builtins.attrNames profiles.profiles)}";
          callerContext = profiles.context or "server";
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs username homeDirectory;
              activeProfile = callerProfile;
              context = callerContext;
            } // extraSpecialArgs;
            modules = [ ./home.nix ] ++ extraModules;
          };
    };
}
