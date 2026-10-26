<div align="center">
<img alt="nix-warcraft icon" src="assets/nix-warcraft.svg" width="128" height="128" />

# nix-warcraft

This flake provides declarative World of Warcraft addon management for Home
Manager on NixOS and nix-darwin.
</div>

## Features

- Declarative addon management
- Proton wrapper
- WTF backup (WIP)
- Edit mode layout can be applied declaratively

## Usage

Add `nix-warcraft` and Home Manager to your flake inputs. This example uses a
standalone Home Manager configuration:

```nix
{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-warcraft.url = "github:raccube/nix-warcraft";
  };

  outputs = {nixpkgs, home-manager, nix-warcraft, ...}: let
    system = "x86_64-linux";
  in {
    homeConfigurations.example = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {inherit nix-warcraft;};
      modules = [./home.nix];
    };
  };
}
```

In the `home.nix` referenced above, import the module and enable the addons:

```nix
{nix-warcraft, pkgs, ...}: {
  imports = [nix-warcraft.homeManagerModules.default];

  # Make the add-on packages available as pkgs.wow-addons.
  nixpkgs.overlays = [nix-warcraft.overlays.default];

  programs.wow = {
    enable = true;
    versions.retail = {
      addonPackages = with pkgs.wow-addons; [
        bigwigs.core
        narcissus
      ];

      # Link a locally checked-out addon directly into WoW while developing it.
      developmentAddons.MyAddon = "/home/user/src/MyAddon";
    };
  };
}
```

The attribute name must match the addon's directory name. Use `$HOME` in the
source path when the checkout location differs between machines.

Packaged addons are installed as writable copies so Battle.net can update the game.
Activation restores managed addons to their packaged contents. By default,
`mutableAddOns = false` also removes unmanaged addons; set it to `true` to preserve
them. Development addons remain linked to their local source directories.

Run `wow-proton-init` to initialize the Proton prefix, then run `wow-battlenet-install --download` to download the Battle.net client.
