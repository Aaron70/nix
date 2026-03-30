{ lib, ... }: 

with lib;
{

  flake.nixosModules.configurations = { config, ... }: {
    config = mkIf config.information.hasBluetooth {
      services.blueman.enable = true;

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    };
  };

}
