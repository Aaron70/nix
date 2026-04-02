{ self, lib, ... }: 

with lib;
let
  name = "cowsay";
in {
  flake.nixosModules.programs = self.lib.mkNixosProgram name ({ ... }: {});
  flake.programs.${name} = self.lib.mkProgram name ({ pkgs, ... }: {
    config = {
      package = pkgs.${name};
    };
  });
}
