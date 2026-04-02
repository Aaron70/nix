{ inputs, self, lib, ... }: 

with lib;
let
  name = "shell";
  shell = "zsh";
in {

  flake.nixosModules.programs = self.lib.mkNixosProgram name ({ config, cfg, ... }: let
    shellPackage = cfg.package; 
  in {
      programs.${shell}.enable = true;
      environment.pathsToLink = [ "/share/${shell}" ];

      users.defaultUserShell = shellPackage;
      users.users.${config.profile.user.username}.shell = shellPackage;

      environment.systemPackages = [
        shellPackage
      ] ++ cfg.configurations.packages;

      environment.variables = rec {
        GIT_AUTHOR_NAME = config.profile.user.username;
        GIT_AUTHOR_EMAIL = config.profile.user.email;
        GIT_COMMITER_NAME = GIT_AUTHOR_NAME;
        GIT_COMMITER_EMAIL = GIT_AUTHOR_EMAIL;
      };

      environment.shellAliases = {
        ntest = "nh os test -H ${config.information.hostname}";
        nswitch = "nh os switch -H ${config.information.hostname}";
        nbuild-vm = "nh os build-vm -H ${config.information.hostname}";
      };
  });

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

  flake.wrappers.${name} = { ... }: {
    imports = [
      self.wrapperModules.${shell}
    ];
  };

  flake.definitions.programs.${name} = { pkgs, config, ... }: {
    options.configurations = {
      shellAliases = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        description = "An attrSet with shell aliases.";
        default = {
          lg = "lazygit";
          eza = "eza --icons auto --git --group-directories-last";
          ls = "eza";
          find = "fd";
          cd = ". cdfzf";
          nshell = "nix-shell -p";
        };
      };

      envVariables = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        description = "An attrSet with environment variables.";
        default = {
          TERM = "tmux-256color";
          NH_FLAKE = "~/nix";
        };
      };

      packages = mkOption {
        type = types.listOf types.package;
        description = "An list of packages to install.";
          default = with pkgs; [
          # Dependencies
          chafa
          eza
          fd
          file
          fzf
          gcc
          gh
          git
          git-crypt
          imgcat
          lazygit
          nh
          ripgrep
          sesh
          television
          wl-clipboard
          zoxide

          # Wrapped
          config.configurations.multiplexer
          inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim

          # Scripts
          (writeShellScriptBin "hydrate-paths" (readFile ./scripts/hydrate-paths.sh))
          (writeShellScriptBin "custom-fzf-preview" (readFile ./scripts/custom-fzf-preview.sh))
          (writeShellScriptBin "cdfzf" (readFile ./scripts/cdfzf.sh))
          (writeShellScriptBin "toggle-tmux-popup" (readFile ./scripts/toogle-tmux-popup.sh))
          (writeShellScriptBin "sessions" (readFile ./scripts/sessions.sh))
        ];
      };

      shellPrompt = mkOption {
        type = types.package;
        description = "The shell prompt package.";
        default = self.wrappers.oh-my-posh.wrap { inherit pkgs; };
      };

      multiplexer = mkOption {
        type = types.package;
        description = "The wrapped and configured terminal multiplexer.";
        default = let shellPath = getExe config.package; in (self.wrappers.tmux.wrap { 
          inherit pkgs; 
          shell = shellPath;
        });
      }; 
    };
  };

}
