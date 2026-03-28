{ self, lib, ... }: 

with lib;
{
  flake.wrappers.ghostty = { config, ... }: {
    imports = [ 
      self.modules.generic.terminal
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
