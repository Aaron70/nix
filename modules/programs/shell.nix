{ self, lib, ... }: 

with lib;
let
  shell = "zsh";
in {

  flake.nixosModules.shell = { pkgs, config, ... }: {
    config = let 
      shellPackage = self.wrappers.shell.wrap { inherit pkgs; };
    in {

      programs.${shell}.enable = true;
      environment.pathsToLink = [ "/share/${shell}" ];

      users.defaultUserShell = shellPackage;
      users.users.${config.profile.user.username}.shell = shellPackage;

      environment.systemPackages = [
        shellPackage
      ] ++ config.configurations.packages;
    };
  };

  flake.wrappers.shell = { ... }: {
    imports = [
      self.wrapperModules.${shell}
    ];
  };

  flake.modules.generic.shell = { pkgs, config, ... }: {
    options.configurations = {
      shellAliases = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        description = "An attrSet with shell aliases.";
      };

      envVariables = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        description = "An attrSet with environment variables.";
      };

      packages = mkOption {
        type = types.listOf types.package;
        description = "An list of packages to install.";
      };

      shellPrompt = mkOption {
        type = types.package;
        description = "The shell prompt package.";
      };

      gitPackage = mkOption {
        type = types.package;
        description = "The wrapped and configured git package.";
      };

      multiplexer = mkOption {
        type = types.package;
        description = "The wrapped and configured terminal multiplexer.";
      }; 
    };

    config.configurations = {
      shellPrompt = self.wrappers.oh-my-posh.wrap { inherit pkgs; };
      gitPackage = self.wrappers.git.wrap { inherit pkgs; };
      multiplexer = let shellPath = getExe config.package; in (self.wrappers.tmux.wrap { 
        inherit pkgs; 
        shell = shellPath;
      });

      shellAliases = {
        lg = "lazygit";
        eza = "eza --icons auto --git --group-directories-last";
        ls = "eza";
        find = "fd";
      };

      envVariables = {
        TERM = "tmux-256color";
      };

      packages = with pkgs; [
        # Dependencies
        eza
        fd
        fzf
        gcc
        lazygit
        nh

        # Wrapped
        config.configurations.gitPackage
        config.configurations.multiplexer
      ];
    };
  };

}
