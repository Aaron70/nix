{ self, lib, ... }: 

with lib;
let
  terminal = "ghostty";
in {

  flake.nixosModules.terminal = { pkgs, ... }: {
    imports = [
      self.nixosModules.shell
    ];

    environment.systemPackages = [
      (self.wrappers.terminal.wrap { inherit pkgs; })
    ];
  };

  flake.wrappers.terminal = { ... }: {
    imports = [
      self.wrapperModules.${terminal}
    ];
  };

  flake.modules.generic.terminal = { pkgs, ... }: {
    options.configurations = {
      shellPackage = mkOption {
        type = types.package;
        description = "The wrapped and configured shell package.";
      };

      theme = {
        package = mkOption {
          type = types.package;
          description = "The package of the theme, if any.";
        };
        path = mkOption {
          type = types.str;
          description = "A path to the theme file, if any.";
        };
      };
    };

    config.configurations = {
      shellPackage = self.wrappers.shell.wrap { inherit pkgs; };

      theme = rec {
        package = pkgs.vimPlugins.tokyonight-nvim;
        path = "${package}/extras/ghostty/tokyonight_moon";
      };
    };
  };

}
