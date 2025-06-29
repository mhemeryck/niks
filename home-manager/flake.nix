{
  description = "Home Manager configuration of mhemeryck";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            oh-my-posh = final.stdenv.mkDerivation {
              pname = "oh-my-posh";
              version = "v25.23.3";

              src = final.fetchurl {
                url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v25.23.3/posh-linux-amd64";
                sha256 = "sha256-q7MgTdM6oKZv2gpaYv+j3K4pNW83Cz99rb5+GRjj6Rw=";
              };

              phases = [ "installPhase" ];

              installPhase = ''
                mkdir -p $out/bin
                cp $src $out/bin/oh-my-posh
                chmod +x $out/bin/oh-my-posh
              '';

              meta.mainProgram = "oh-my-posh";
            };
          })
        ];
      };
    in
    {
      homeConfigurations."mhemeryck" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
