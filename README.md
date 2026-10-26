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
- Automatic Warcraft Logs uploads after each encounter (Archon Lite)

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

## Automatic combat log uploads

Enable live logging for a configured game version:

```nix
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) ["archon-lite"];

  programs.wow.logs = {
    enable = true;
    version = "retail";
    region = 2; # EU; US=1, KR=3, TW=4, CN=5
    visibility = "unlisted";
    # guildId = 12345;
  };
}
```

Archon Lite starts with your graphical desktop session and watches that version's
`Logs` directory. On first use, sign in to Warcraft Logs in the app and select
World of Warcraft and the appropriate game flavour. If `guildId` is unset, the app
uses its saved destination; select Personal Logs there for personal reports.
The uploader starts live logging automatically and sends completed fights rather
than streaming during combat. Authentication stays in the app's local profile.

An included addon enables advanced combat logging and records the entire time
spent in raids and dungeons, including trash. It stops logging when you leave.
Set `autoCombatLogging = false` if another addon already manages logging.
For Classic, also set `interfaceVersion` to your client's TOC interface version.

By default, live logging only uploads new data after the uploader starts; it does
not upload older sessions already in the file. Start it before entering an instance.
Use `wow-log-uploader` to start it manually after activation, or set
`autoStart = false` to always start it yourself. Close an existing Archon Lite
instance before using this launcher so its live logging arguments take effect.
Restart it after changing uploader options.

The bundled app supports x86_64 Linux and macOS. Linux autostart requires a desktop
that activates Home Manager's `graphical-session.target`. Override `logs.directory`
if your combat logs are stored elsewhere. Uploads require a Warcraft Logs account
and a network connection; the game client must load the Nix Auto Logging addon.
