{ ... }: {
  perSystem = { pkgs, ... }:
    let
      setupScript = pkgs.writeShellApplication {
        name = "cabanashmul-setup";
        runtimeInputs = [ pkgs.git pkgs.coreutils pkgs.openssh pkgs.gh ];
        text = builtins.readFile ../scripts/setup.sh;
      };
    in {
      packages.setup = setupScript;
      apps.setup = {
        type = "app";
        program = "${setupScript}/bin/cabanashmul-setup";
      };
    };
}
