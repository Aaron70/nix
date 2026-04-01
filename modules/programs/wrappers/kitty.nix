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
        font_family      JetBrainsMono Nerd Font
        bold_font        auto
        italic_font      auto
        bold_italic_font auto

        shell ${getExe config.configurations.shell}
      '';
    };
  };
}
