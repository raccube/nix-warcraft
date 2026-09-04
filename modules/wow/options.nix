{
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}: let
  toTitleCase = str: let
    first = lib.strings.toUpper (lib.strings.substring 0 1 str);
    rest = lib.strings.replaceString "-" " " (lib.strings.substring 1 (lib.stringLength str) str);
  in
    lib.concatStrings [first rest];
  versionOpts = {
    name,
    config,
    ...
  }: {
    options = {
      addonPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Nix packages providing the addons for this WoW flavour.";
      };

      displayName = lib.mkOption {
        type = lib.types.str;
        default =
          if name == "retail"
          then "World of Warcraft"
          else "World of Warcraft ${toTitleCase name}";
        description = "Name shown for this install's desktop entry.";
      };

      executable = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "WoW executable relative to the Proton compatibility-data directory. Defaults based on the version name.";
      };

      mutableAddOns = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to allow AddOns not managed by this flake in the AddOns directory.";
      };
    };
  };
in {
  options.programs.wow = {
    enable = lib.mkEnableOption "declarative WoW addon management";

    protonPackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = lib.mkDefault inputs.proton-ge-nix.packages.${pkgs.stdenv.hostPlatform.system}.v11.steamcompattool;
      description = "Proton package used to run World of Warcraft.";
    };

    addonDir = lib.mkOption {
      type = lib.types.str;
      description = "Path to Interface/AddOns directory.";
      example = ".local/share/wineprefixes/battlenet-wow/pfx/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns";
      default =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Applications/World of Warcraft/_retail_/Interface/AddOns"
        else ".local/share/wineprefixes/battlenet-wow/pfx/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns";
    };

    prefixDir = lib.mkOption {
      type = lib.types.str;
      default = ".local/share/wineprefixes/battlenet-wow";
      description = "Directory containing the manually managed Battle.net/WoW Proton compatibility data.";
    };

    battleNetExe = lib.mkOption {
      type = lib.types.str;
      default = "pfx/drive_c/Program Files (x86)/Battle.net/Battle.net.exe";
      description = "Battle.net executable relative to the Proton compatibility-data directory.";
    };

    wowDir = lib.mkOption {
      type = lib.types.str;
      default = "pfx/drive_c/Program Files (x86)/World of Warcraft";
      description = "World of Warcraft executable relative to the Proton compatibility-data directory.";
    };

    wowExe = lib.mkOption {
      type = lib.types.str;
      default = "pfx/drive_c/Program Files (x86)/World of Warcraft/_retail_/Wow.exe";
      description = "World of Warcraft executable relative to the Proton compatibility-data directory.";
    };

    battleNetAppId = lib.mkOption {
      type = lib.types.str;
      default = "1000000001";
      description = "Synthetic Steam app ID used to identify Battle.net windows launched through Proton.";
    };

    wowAppId = lib.mkOption {
      type = lib.types.str;
      default = "1000000002";
      description = "Synthetic Steam app ID used to identify World of Warcraft windows launched through Proton.";
    };

    hideDesktopEntries = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to hide the desktop entries for World of Warcraft.";
    };

    versions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule versionOpts
      );
      default = {};
      description = "State of the World of Warcraft versions to manage.";
    };

    uiLayoutName = lib.mkOption {
      type = lib.types.str;
      default = osConfig.networking.hostName;
      description = "Edit Mode layout to use (assuming it exists).";
    };

    uiLayoutFallback = lib.mkOption {
      type = lib.types.str;
      default = "16:9";
      description = "Edit Mode layout name to use when hostname has no mapping in uiLayouts.";
    };

    wtfSync = {
      enable = lib.mkEnableOption "sync WTF directory to git after game exit";

      remoteUrl = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Git remote URL for the WTF repository.";
        example = "git@forgejo.example.com:kkwiatek/wow-wtf.git";
      };

      wtfDir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Override path to WTF directory. Defaults to _retail_/WTF derived from addonDir.";
      };

      branch = lib.mkOption {
        type = lib.types.str;
        default = "retail";
        description = "Git branch to push/pull WTF sync.";
      };

      syncPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["Account"];
        description = "Paths within WTF directory to track in git.";
      };

      processPattern = lib.mkOption {
        type = lib.types.str;
        default = "Wow.exe|WowClassic.exe";
        description = "Process name pattern to watch for WoW exit detection (passed to pgrep -f).";
      };
    };
  };
}
