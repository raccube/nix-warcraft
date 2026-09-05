{
  description = "Declarative World of Warcraft management for NixOS, Home Manager, and nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    proton-ge-nix.url = "github:Daaboulex/proton-ge-nix";
    proton-ge-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    homeManagerModules.default = ./modules/wow;

    overlays.default = final: prev: {
      wow-addons = import ./pkgs/wow-addons {pkgs = final;};
    };

    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      addons = import ./pkgs/wow-addons {inherit pkgs;};
      packageAddons =
        pkgs.lib.mapAttrs (
          name: value:
            if pkgs.lib.isDerivation value
            then value
            else
              pkgs.symlinkJoin {
                inherit name;
                paths = pkgs.lib.attrValues value;
              }
        )
        addons;
    in
      packageAddons
      // {
        wow-addons = pkgs.symlinkJoin {
          name = "wow-addons";
          paths = pkgs.lib.attrValues packageAddons;
        };
        home-manager-wow-ui-layout = pkgs.callPackage ./pkgs/home-manager-wow-ui-layout {
          layoutName = "retail";
          layoutFallback = "16:9";
        };
      });

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
