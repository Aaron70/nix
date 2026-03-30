{ lib, ... }: 

with lib;
{

  flake.nixosModules.configurations = { config, ... }: {
    config =  let
      isvmtest = config.profile.user.username == "vmtest";
    in {
      users.users.${config.profile.user.username} = {
        isSystemUser = true;
        description = config.profile.user.fullname;
        extraGroups = [ "networkmanager" "wheel" "audio" ];

        # Only for vmtest user: sudo nixos-rebuild build-vm
        initialPassword = mkIf isvmtest "test";
        group = mkIf isvmtest "vmtest";
      };
      users.groups = mkIf isvmtest { vmtest = {}; };
    };
  };

}
