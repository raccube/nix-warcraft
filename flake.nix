{
  description = "Declarative World of Warcraft management for NixOS, Home Manager, and nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    proton-ge-nix.url = "github:Daaboulex/proton-ge-nix";
    proton-ge-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    proton-ge-nix,
    ...
  }: let
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
      addonPackages = pkgs.lib.flatten (pkgs.lib.mapAttrsToList (
          _: value:
            if pkgs.lib.isDerivation value
            then [value]
            else if pkgs.lib.isAttrs value
            then pkgs.lib.attrValues value
            else [value]
        )
        addons);
    in
      addons
      // {
        wow-addons = pkgs.symlinkJoin {
          name = "wow-addons";
          paths = addonPackages;
        };
        home-manager-wow-ui-layout = pkgs.callPackage ./pkgs/home-manager-wow-ui-layout {
          layoutName = "retail";
          layoutFallback = "16:9";
        };
      });

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
