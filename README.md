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

Add the flake to your flake inputs:

```nix
{
  inputs.nix-warcraft.url = "github:raccube/nix-warcraft";
}
```

Then, use the `nix-warcraft` module in your Home Manager configuration:

```nix
{
  # Add the package overlay
  nixpkgs.overlays = [inputs.nix-warcraft.overlays.default];
  
  programs.wow = {
    enable = true;
    versions.retail.addonPackages = with pkgs.wow-addons; [
      # list your addons here ...
      bigwigs.core
      narcissus
    ];
  };
}
```

Run `wow-proton-init` to initialize the Proton prefix, then run `wow-battlenet-install --download` to download the Battle.net client.
