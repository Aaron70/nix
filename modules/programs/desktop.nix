{ inputs, self, lib, ... }: 

with lib;
let
  name = "desktop";
  desktop = "niri";
in {

  # flake.nixosModules.desktop = { pkgs, config, ... }: {
  #   imports = [
  #     self.programs.desktop
  #   ];
  #
  #   options.preferences.programs.desktop = {
  #     enable = mkEnableOption "Whether to enable the desktop environment.";
  #
  #     modKey = mkOption {
  #       type = types.str;
  #       description = "The mod key to be used by the window manager.";
  #       default = "super";
  #     };
  #
  #     modKeyAlt = mkOption {
  #       type = types.str;
  #       description = "The alternative mod key to be used by the window manager.";
  #       default = "alt";
  #     };
  #   };
  #
  #   config = mkIf config.preferences.programs.desktop.enable {
  #     services.displayManager.gdm.enable = true;
  #     programs.${desktop} = {
  #       enable = true;
  #       package = self.wrappers.desktop.wrap { 
  #         inherit pkgs;
  #         configurations = {
  #           modKey = config.preferences.programs.desktop.modKey;
  #           modKeyAlt = config.preferences.programs.desktop.modKeyAlt;
  #         };
  #       };
  #     };
  #
  #     environment.systemPackages = with pkgs; [
  #       # Applications
  #       spotify
  #
  #       # Essentials
  #       vlc # Videos
  #       shotwell # Images
  #       mission-center
  #     ] ++ config.configurations.packages;
  #   };
  # };

  flake.nixosModules.programs = self.lib.mkNixosProgram name ({ pkgs, cfg, ... }: {
    config = {
      services.displayManager.gdm.enable = true;
      programs.${desktop} = {
        enable = true;
        package = self.wrappers.${name}.wrap { 
          inherit pkgs;
          configurations = cfg.configurations;
        };
      };

      # TODO : Remove this
      environment.shellAliases = { works = "echo works"; };

      environment.systemPackages = with pkgs; [
        # Applications
        spotify

        # Essentials
        vlc # Videos
        shotwell # Images
        mission-center
      ] ++ cfg.configurations.packages;
    };
  });

  flake.programs.${name} = self.lib.mkProgram name ({ pkgs, cfg, config, ... }@inputs: let
    definition = self.definitions.programs.${name} inputs;
  in {
    options = definition.options;
    config = {
      package = self.wrappers.${name}.wrap {
        inherit pkgs;
        configurations = cfg.configurations;
      };
    } // definition.config;
  });

  flake.wrappers.${name} = { ... }: {
    imports = [
      self.wrapperModules.${desktop}
    ];
  };

  flake.definitions.programs.${name} = { pkgs, config, ... }: {
    options.configurations = {
      modKey = mkOption {
        type = types.str;
        description = "The mod key to be used by the window manager.";
        default = "super";
      };

      modKeyAlt = mkOption {
        type = types.str;
        description = "The alternative mod key to be used by the window manager.";
        default = "alt";
      };

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
        default = pkgs.makeFontsConf {
          fontDirectories = with pkgs; [
            nerd-fonts.jetbrains-mono
          ];
        };
      };
    };

    config.configurations = let
      noctalia-shell = (self.wrappers.noctalia.wrap { inherit pkgs; });
    in rec {
      terminal = mkDefault (self.wrappers.terminal.wrap { inherit pkgs; });
      browser = mkDefault inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
      desktopShell = mkDefault noctalia-shell;
      appLauncher = mkDefault (pkgs.writeShellScriptBin "launcher" "${getExe noctalia-shell} ipc call launcher toggle");
      packages = with pkgs; mkDefault  [
        # Wrappers
        terminal
        browser
        desktopShell
        appLauncher

        # Dependencies
        pavucontrol
        playerctl
        brightnessctl
      ];
    };
  };
}
