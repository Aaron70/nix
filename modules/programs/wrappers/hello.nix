{ self, lib, ... }: 

with lib;
let 
  name = "hello";
in {

  flake.programs.${name} = self.lib.mkProgram name ({ pkgs, cfg, ... }@inputs: let
    definition = self.definitions.programs.${name} inputs;
  in {
    options = definition.options;
    config = {
      package = self.wrappers.${name}.wrap {
        inherit pkgs;
        configurations = cfg.configurations;
      };
    };
  }); 

  flake.nixosModules.programs = self.lib.mkNixosProgram name ({ ... }: {});

  flake.definitions.programs.${name} = { ... }: {
    options.configurations = {
      greeting = mkOption {
        type = types.str;
        description = "The Ghostty configuration file's contents.";
        default = "Hello program!";
      };
    };
  };

  flake.wrappers.${name} = { config, wlib, pkgs, ... }: {
    imports = [
      self.definitions.programs.${name}
      wlib.modules.default 
    ];

    config = {
      package = pkgs.hello;
      # flagSeparator="=";
      # flags."-g" = mkIf (cfg.configurations.greeting != "") cfg.configurations.greeting;
      flags."-g" = config.configurations.greeting;
    };
  };
}
