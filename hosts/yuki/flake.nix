{
  inputs = {
    # NixOS official package source, here using the nixos-24.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    wezterm-flake.url = "github:wez/wezterm/main?dir=nix";
    wezterm-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.yuki = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
