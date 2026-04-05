{ self, lib, ... }: 

with lib;
let
  name = "kitty";
in {

  flake.nixosModules.programs = self.lib.mkNixosProgram name ({ ... }: {});

  flake.programs.${name} = self.lib.mkProgram name ({ ... }: {
    configurations = [ self.definitions.programs.terminal ];
  });

  flake.wrappers.${name} = { config, ... }: {
    imports = [ 
      self.definitions.programs.terminal
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
