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
        confirm_os_window_close 0 
        enable_audio_bell false

        shell ${getExe config.configurations.shell}
      '';
    };
  };
}
