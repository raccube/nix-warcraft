# WoW Nix flake

This flake provides declarative World of Warcraft addon management for Home
Manager on NixOS and nix-darwin.

Outputs:

- `homeManagerModules.default` — the `programs.wow` module and launchers;
- `overlays.default` — the pinned `wow-addons` package set;
- `packages.<system>.<addon>` — individual addon packages;
- `packages.<system>.wow-addons` — the complete addon collection.

The parent workstation flake consumes this directory as the `wow` input. It
can be moved into its own repository without changing the exported interface.
