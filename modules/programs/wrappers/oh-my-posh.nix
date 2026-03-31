
{ self, lib, ... }: 

with lib;
{
  flake.wrappers.oh-my-posh = { pkgs, config, ... }: 
  {
    imports = [ 
      self.wrapperModules._oh-my-posh 
      self.wrapperHelpers.modules.theme
    ];
    config = let colors = config.colors; in {
      extraPackages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
      configuration = self.wrapperHelpers.oh-my-posh.prompts.custom { inherit colors; };
    };
  };
 }
