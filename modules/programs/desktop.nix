{ inputs, self, lib, ... }: 

with lib;
let
  desktop = "niri";
in {

  flake.nixosModules.desktop = { pkgs, config, ... }: {
    imports = [
      self.modules.generic.desktop
      self.nixosModules.terminal
    ];

    options.preferences.desktop = {
      enable = mkEnableOption "Whether to enable the desktop environment.";
    };

    config = mkIf config.preferences.desktop.enable {
      services.displayManager.gdm.enable = true;
      programs.${desktop} = {
        enable = true;
        package = self.wrappers.desktop.wrap { 
          inherit pkgs; 
        };
      };

      environment.systemPackages = with pkgs; [
        spotify
        discord
      ];
    };
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

      browser = mkOption {
        type = types.package;
        description = "The wrapped and configured browser package.";
      };

      desktopShell = mkOption {
        type = types.package;
        description = "The wrapped and configured desktop shell package.";
      };

      appLauncher = mkOption {
        type = types.package;
        description = "The wrapped and configured app launcher package.";
      };

      packages = mkOption {
        type = types.listOf types.package;
        description = "An list of packages to install.";
      };

      fontsConfig = mkOption {
        type = types.package;
        description = "The package with the font configurations. Export FONTCONFIG_FILE=\${fontsConfig} to apply the fonts.";
      };
    };

    config.configurations = rec {
      terminal = self.wrappers.terminal.wrap { inherit pkgs; };
      browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
      desktopShell = self.wrappers.noctalia.wrap { inherit pkgs; };
      appLauncher = (pkgs.writeShellScriptBin "launcher" "${getExe desktopShell} ipc call launcher toggle");

      packages = with pkgs; [
        terminal
        browser
        desktopShell
        appLauncher
      ];

      fontsConfig = pkgs.makeFontsConf {
        fontDirectories = with pkgs; [
          nerd-fonts.jetbrains-mono
        ];
      };
    };
  };
}
