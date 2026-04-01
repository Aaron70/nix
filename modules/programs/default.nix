{ inputs, ... }: 

{
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      programs = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };
}
