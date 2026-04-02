{ self, lib, ... }: 

with lib;
let
  name = "ghostty";
in {

  flake.nixosModules.programs = self.lib.mkNixosProgram name ({ ... }: {});

  flake.programs.${name} = self.lib.mkProgram name ({ pkgs, cfg, ... }@inputs: let
    definition = self.definitions.programs.terminal inputs;
  in {
    options = definition.options;
    config = {
      package = self.wrappers.${name}.wrap {
        inherit pkgs;
        configurations = cfg.configurations;
      };
    };
  });

  flake.wrappers.${name} = { config, ... }: {
    imports = [ 
      self.definitions.programs.terminal
      self.wrapperModules._ghostty 
    ];

    config = {
      configuration = ''
        theme=${config.configurations.theme.path}
        command=${getExe config.configurations.shell}
      '';
    };
  };
}
