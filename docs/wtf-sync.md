# WTF synchronization

WTF synchronization is disabled by default. When enabled, the module watches
for WoW to exit, pulls the configured branch, and pushes selected WTF paths
after the game has finished writing its files.

```nix
programs.wow.wtfSync = {
  enable = true;
  remoteUrl = "git@forgejo.example.com:you/wow-wtf.git";
  branch = "retail";
  syncPaths = ["Account" "Config.wtf"];
};
```

The generated `wow-wtf-sync` command performs a synchronization immediately.
Use `wow-wtf-sync --pull-only` when you only want to fetch and rebase without
committing local changes. The `wow-wtf-resolve` command starts the configured
Meld-based merge-tool flow when a rebase has conflicts.

Only paths listed in `syncPaths` are included. The generated `.gitignore`
ignores everything else in the WTF directory, which helps avoid accidentally
committing unrelated game data.

The watcher is intended for Linux and uses the configured `processPattern` to
detect WoW processes. Make sure the remote is writable by the user running
Home Manager before enabling automatic pushes.
