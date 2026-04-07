{ self, lib, ... }: 

with lib;
let
  name = "gaming";
in {

  flake.nixosModules.features = self.lib.mkNixosFeature name ({ ... }: { });

  flake.features.${name} = self.lib.mkFeature name ({ pkgs, ... }: {
    config = {
      programs = {
        steam.enable = true;
      };

      packages = with pkgs; [
        # Communication
        discord

        # Games
        ryubing # Nintendo Switch simulator
        pokemmo-installer # PokeMMO
        (heroic.override { extraPkgs = pkgs: [ pkgs.gamescope ]; }) # Epic Games Launcher

        # Tools/Dependencies/Compatibility
        mangohud
        protonup-ng
      ];
    };
  });
 }
