{
  description = "Nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixgl.url   = "github:nix-community/nixGL";
  };

  outputs = { self, nixgl, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
        localSystem.system = system;
        overlays = [ nixgl.overlay ];
    };
    packagesList = import ./packages.nix { inherit pkgs; };
  in
  {
      packages.${system}.default = pkgs.buildEnv {
          name = "default-packages";
          paths = packagesList;
      };

      # Exposed meta-package attributes for inspection
      metaPackages.${system}.default.pkgs = packagesList;           
  };
}
