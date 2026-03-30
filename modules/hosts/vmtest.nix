{ inputs, self, ... }: 

{
  flake.nixosConfigurations.vmtest = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.vmtest ];
  };

  flake.nixosModules.vmtest = { modulesPath, ... }: {
    imports = [ 
      self.nixosModules.configurations 
      "${modulesPath}/virtualisation/qemu-vm.nix" 
    ];

    preferences = {
      profile = "vmtest";

      desktop.enable = true;
    };

    virtualisation.graphics = true;
    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display gtk,gl=on"
    ];

    environment.systemPackages = [
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
