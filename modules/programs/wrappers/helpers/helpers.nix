{ inputs, ... }: 

{
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrapperHelpers = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };
}
