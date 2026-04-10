{ inputs, self, lib, ... }: 

with lib;
{

  flake.nixosModules.configurations = { config, ... }: {
    imports = [ inputs.home-manager.nixosModules.default ];

    config = {
      home-manager.users.${config.profile.user.username} = { ... }: {
        imports = [
          self.homeModules.configurations
        ];
        config = {
          programs.home-manager.enable = true;
          home = {
            username = config.profile.user.username;
            homeDirectory = "/home/${config.profile.user.username}";
            stateVersion = config.preferences.stateVersion;
          };
        };
      };
    };
  };

}
