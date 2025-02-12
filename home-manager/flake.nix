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

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."mhemeryck" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home.nix
            {
              # Override google-cloud-sql-proxy version
              nixpkgs.overlays = [
                (self: super: {
                  google-cloud-sql-proxy =
                    super.google-cloud-sql-proxy.overrideAttrs (old: {
                      version = "2.12.0"; # Specify the desired version
                      src = super.fetchFromGitHub {
                        owner = "GoogleCloudPlatform";
                        repo = "cloudsql-proxy";
                        rev = "v2.12.0";
                        hash =
                          "sha256-nEbrNRrEXXvLYi1vIvukUaq+WQn2HlonaaMn57yIA3I=";
                      };

                      vendorHash =
                        "sha256-EI2PDVdS9JB8ACkRTsfCBLz4JEmHQ6hApFSSfSvD/cQ=";
                      subPackages = [ "." ];
                      checkFlags = [ "-short" ];
                    });
                })
              ];
            }
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
    };
}
