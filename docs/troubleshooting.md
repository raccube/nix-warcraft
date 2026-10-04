# Troubleshooting

## `wow-proton-init` cannot find Steam Linux Runtime 4

Install **Steam Linux Runtime 4** from Steam's **Tools** section. The launcher
uses that runtime to run Proton and will stop if its entry point is not found.

## The game executable is missing

Run `wow-battlenet-install --download`, sign in to Battle.net, and install the
game into the configured prefix. The generated WoW launcher does not download
or install the game itself.

## An addon is not present in-game

Confirm that the addon is in the version's `addonPackages` list and that the
overlay is enabled. Then apply the Home Manager configuration again. Addons
are linked into the configured `Interface/AddOns` directory; with
`mutableAddOns = false`, manually copied addons are removed from the managed
set on activation.

## WTF synchronization reports a conflict

Stop WoW, inspect the conflict in the version's WTF directory, and run
`wow-wtf-resolve`. Resolve the files in Meld, then let the command continue the
rebase. Check the configured remote and branch if the initial fetch fails.
