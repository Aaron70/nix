{ self, lib, ... }: 

with lib;
{
  flake.nixosModules.features = { config, ... }: {
    imports = [ 
      self.features.gaming 
      self.nixosModules.steam
    ];

    config = {
      preferences.programs = {
        steam = true;
      };

      environment.systemPackages = config.preferences.features.gaming;
    };
  };

  flake.features.gaming = { pkgs, ... }: {
    options.preferences.features.gaming = {
      enable = mkEnableOption "Whether to enable the gaming feature.";

      packages = mkOption {
        type = types.listOf types.package;
        description = "An list of packages to install.";
      };
    };

    config = mkIf config.features.gaming.enable {
      features.gaming = {
        packages = with pkgs; [
          # Games
          ryubing # Nintendo Switch simulator
          pokemmo-installer
          (heroic.override { extraPkgs = pkgs: [ pkgs.gamescope ]; })

          # Tools/Dependencies/Compatibility
          mangohud
          protonup-ng
        ];
      };
    };
  }; 
}
