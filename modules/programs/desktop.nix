{ self, lib, ... }: 

with lib;
let
  desktop = "niri";
in {

  flake.nixosModules.desktop = { pkgs, config, ... }: {
    imports = [
      self.modules.generic.desktop
      self.nixosModules.terminal
    ];

    services.displayManager.gdm.enable = true;
    programs.${desktop} = {
      enable = true;
      package = self.wrappers.desktop.wrap { 
        inherit pkgs; 
      };
    };

    environment.systemPackages = config.configurations.packages;
  };

  flake.wrappers.desktop = { ... }: {
    imports = [
      self.wrapperModules.${desktop}
    ];
  };

  flake.modules.generic.desktop = { pkgs, ... }: {
    options.configurations = {
      terminal = mkOption {
        type = types.package;
        description = "The wrapped and configured terminal package.";
      };

      packages = mkOption {
        type = types.listOf types.package;
        description = "An list of packages to install.";
      };
    };

    config.configurations = {
      terminal = self.wrappers.terminal.wrap { inherit pkgs; };

      packages = with pkgs; [
        fuzzel
      ];
    };
  };

}
