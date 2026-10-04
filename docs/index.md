# nix-warcraft

`nix-warcraft` provides declarative World of Warcraft management for Home
Manager on NixOS and nix-darwin. It packages addons, creates launchers for
Battle.net and WoW, and can keep selected WTF files in a Git repository.

The project is a Nix flake. Add it to the flake that owns your Home Manager
configuration, import its module, and declare the WoW versions and addons you
want to manage.

## What it provides

- Declarative addon installation from Nix packages.
- Proton initialization and Battle.net/WoW launchers on Linux.
- Optional Edit Mode layout deployment.
- Optional Git-based WTF synchronization.

The source repository and issue tracker are available at
<https://github.com/raccube/nix-warcraft>.
