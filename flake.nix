{
  description = "magamind - a tiny Home Manager starter for zshmul and tshmux";

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
  };

  outputs = { home-manager, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system =
        if builtins ? currentSystem then builtins.currentSystem else "x86_64-linux";
      username =
        let detected = builtins.getEnv "USER";
        in if detected != "" then detected else "your-username";
      hostname = builtins.getEnv "HOSTNAME";
      pkgs = import nixpkgs { inherit system; };
      homeConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
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
    };
}
