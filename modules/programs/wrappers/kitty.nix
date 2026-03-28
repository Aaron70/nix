{ self, lib, ... }: 

with lib;
{
  flake.wrappers.kitty = { config, ... }: {
    imports = [ 
      self.modules.generic.terminal
      self.wrapperModules._kitty 
    ];

    config = {
      configuration = ''
        include ${config.configurations.theme.path}
        confirm_os_window_close -1

        shell ${getExe config.configurations.shell}
      '';
    };
  };
}
