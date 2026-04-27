# private-inputs.example.nix — documentation only, NOT imported automatically.
#
# Nix flake `inputs` must be a static attrset; dynamic merging at evaluation
# time is not supported. To add private SSH-gated inputs, add them directly
# to the `inputs` block in flake.nix and commit that change to your private
# fork. The entries below show the typical format:
#
# inputs = {
#   # ... existing public inputs ...
#
#   shmulcode = {
#     url = "git+ssh://git@github.com/shmul95/shmulcode";
#     inputs.nixpkgs.follows = "nixpkgs";
#   };
#   shmulistan = {
#     url = "git+ssh://git@github.com/shmul95/shmulistan";
#     inputs.nixpkgs.follows = "nixpkgs";
#   };
#   shmulex = {
#     url = "git+ssh://git@github.com/shmul95/shmulex";
#     inputs.nixpkgs.follows = "nixpkgs";
#   };
# };
#
# After adding inputs, re-run: nix flake update
