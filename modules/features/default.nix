{ inputs, ... }: 

{
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      features = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };
}
