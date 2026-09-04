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
    homeManagerModules.default = moduleArgs:
      import ./modules/wow (moduleArgs
        // {
          protonGe = proton-ge-nix.packages.${moduleArgs.pkgs.stdenv.hostPlatform.system}.v11.steamcompattool;
        });

    overlays.default = final: prev: {
      wow-addons = import ./pkgs/wow-addons {pkgs = final;};
    };

    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      addons = import ./pkgs/wow-addons {inherit pkgs;};
    in
      addons
      // {
        wow-addons = pkgs.symlinkJoin {
          name = "wow-addons";
          paths = pkgs.lib.attrValues addons;
        };
        home-manager-wow-ui-layout = pkgs.callPackage ./pkgs/home-manager-wow-ui-layout {
          layoutName = "retail";
          layoutFallback = "16:9";
        };
      });

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
