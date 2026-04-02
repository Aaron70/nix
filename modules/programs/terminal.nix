{ self, lib, ... }: 

with lib;
let
  name = "terminal";
  terminal = "kitty";
in {

  flake.nixosModules.programs = self.lib.mkNixosProgram name ({ ... }: {});

  flake.programs.${name} = self.lib.mkProgram name ({ cfg, ... }: {
    config = {
      package = self.wrappers.terminal.wrap { 
        inherit pkgs; 
        configurations = cfg.configurations;
      };
    };
  });

  flake.wrappers.${name} = { ... }: {
    imports = [
      self.wrapperModules.${terminal}
    ];
  };

  flake.definitions.programs.${name} = { pkgs, ... }: {
    options.configurations = {
      shell = mkOption {
        type = types.package;
        description = "The wrapped and configured shell package.";
        default = self.wrappers.shell.wrap { inherit pkgs; };
      };

      theme = let themePackage = pkgs.vimPlugins.tokyonight-nvim; in {
        package = mkOption {
          type = types.package;
          description = "The package of the theme, if any.";
          default = themePackage;
        };

        path = mkOption {
          type = types.str;
          description = "A path to the theme file, if any.";
          default = "${themePackage}/extras/kitty/tokyonight_moon.conf";
          # default = "${package}/extras/ghostty/tokyonight_moon";
        };
      };
    };
  };
}
