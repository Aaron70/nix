{ inputs, ... }:

{
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      lib = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };
}
