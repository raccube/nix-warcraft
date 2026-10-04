# Getting started

## Add the flake input

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

## Enable the module

In `home.nix`, import the module and add the overlay that exposes the addon
packages as `pkgs.wow-addons`:

```nix
{nix-warcraft, pkgs, ...}: {
  imports = [nix-warcraft.homeManagerModules.default];

  nixpkgs.overlays = [nix-warcraft.overlays.default];

  programs.wow = {
    enable = true;
    versions.retail.addonPackages = with pkgs.wow-addons; [
      bigwigs.core
      narcissus
    ];
  };
}
```

Apply the Home Manager configuration with your usual command, for example:

```sh
home-manager switch --flake .#example
```

## Install World of Warcraft

On Linux, the module provides commands for preparing the Proton prefix and
installing Battle.net:

```sh
wow-proton-init
wow-battlenet-install --download
```

Sign in to Battle.net and install World of Warcraft. After the game is
installed, launch it with the generated `wow-retail` command. Other version
names, such as `classic` or `ptr`, produce corresponding launchers when they
are configured under `programs.wow.versions`.
