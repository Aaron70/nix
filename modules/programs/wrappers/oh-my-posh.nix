
{ self, lib, ... }: 

with lib;
{
  flake.wrappers.oh-my-posh = { pkgs, config, ... }: let
    yamlToAttrs = file: builtins.fromJSON (builtins.readFile (pkgs.runCommand "yaml-to-json" { buildInputs = [ pkgs.yq-go ]; } ''yq -o=json '.' ${file} > $out''));
    theme = yamlToAttrs "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";
    hexColor = lib.types.strMatching "^#[0-9a-fA-F]{6}$" // {
      description = "6-digit hex color (without '#')";
    };

    base16Slots = [
      "base00" "base01" "base02" "base03"
      "base04" "base05" "base06" "base07"
      "base08" "base09" "base0A" "base0B"
      "base0C" "base0D" "base0E" "base0F"
    ];
  in {
    imports = [ self.wrapperModules._oh-my-posh ];
    options = {
      colors = mkOption {
        type = lib.types.submodule {
          options = lib.genAttrs base16Slots (slot:
            lib.mkOption {
              type = hexColor;
              example = "1a1b26";
              description = "Base16 slot ${slot}.";
            }
          );
        };
        description = "A complete Base16 color scheme (base00–base0F as 6-digit hex strings with '#').";
        default = theme.palette;
      };
    };
    config = let colors = config.colors; in {
      extraPackages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
      configuration = self.wrapperHelpers.oh-my-posh.prompts.robots { inherit colors; };
    };
  };
 }
