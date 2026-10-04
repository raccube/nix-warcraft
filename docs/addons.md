# Addons

The overlay exports the addon collection as `pkgs.wow-addons`. Add packages to
the `addonPackages` list for the WoW version where they should be installed:

```nix
programs.wow.versions.retail.addonPackages = with pkgs.wow-addons; [
  bigwigs.core
  btwquests
  craftsim
  handynotes
  narcissus
];
```

The repository currently packages addons including BigWigs, BTWQuests,
Narcissus, Plumber, HandyNotes, CraftSim, Altoholic, GTFO, Opie, and several
others. The exact package set can change as addon pins are updated.

Some addons expose multiple packages. For example, BigWigs is grouped below
`bigwigs`, so use `bigwigs.core` rather than `bigwigs` itself. Inspect the
package definitions in [`pkgs/wow-addons`](https://github.com/raccube/nix-warcraft/tree/amirdrassil/pkgs/wow-addons)
when you need the exact attribute name.

Addon sources are fetched with fixed hashes. Updates are intentionally visible
in the flake's source and can be reviewed like any other Nix change.
