# Configuration

All options live below `programs.wow`.

## Main options

| Option | Default | Purpose |
| --- | --- | --- |
| `enable` | `false` | Enable WoW management and generated commands. |
| `prefixDir` | `.local/share/wineprefixes/battlenet-wow` | Proton compatibility-data directory. |
| `protonPackage` | Proton-GE from the flake input | Proton package used to run the game. |
| `hideDesktopEntries` | `false` | Hide generated desktop entries. |
| `battleNetExe` | Battle.net executable path | Path relative to `prefixDir`. |
| `wowDir` | WoW installation path | Path relative to `prefixDir`. |
| `wowExe` | Retail executable path | Default WoW executable path. |
| `battleNetAppId` | `1000000001` | Synthetic app ID for Battle.net. |
| `wowAppId` | `1000000002` | Synthetic app ID for WoW launchers. |

Relative paths are interpreted below `$HOME`. Use an absolute path when the
prefix is stored elsewhere.

## Versions

Each attribute under `versions` represents one WoW installation. The most
important options are:

```nix
programs.wow.versions.retail = {
  addonPackages = with pkgs.wow-addons; [bigwigs.core narcissus];
  mutableAddOns = false;
  displayName = "World of Warcraft";
};
```

The supported flavour names have built-in executable defaults for `retail`,
`beta`, `classic`, `classic-era`, `ptr`, and `xptr`. Custom names can be used;
set `executable` when the default `Wow.exe` name is not appropriate.

Per-version options also include `addonDir`, `wtfDir`, and `mutableAddOns`.
By default, the AddOns directory is managed exclusively by Nix. Set
`mutableAddOns = true` to allow addons installed outside this flake.

## Edit Mode layouts

The module installs an Edit Mode layout addon. `uiLayoutName` selects the
layout name, defaulting to the machine hostname, and `uiLayoutFallback`
defaults to `16:9` when no hostname-specific layout is available.
