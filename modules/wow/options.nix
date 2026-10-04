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
  }: let
    wowDir = let
      name' = lib.replaceStrings ["-"] ["_"] name;
    in
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Applications/World of Warcraft/_${name'}_"
      else ".local/share/wineprefixes/battlenet-wow/pfx/drive_c/Program Files (x86)/World of Warcraft/_${name'}_";

    defaultAddonDir = wowDir + "/Interface/AddOns";
    defaultWtfDir = "${builtins.dirOf (builtins.dirOf defaultAddonDir)}/WTF";
  in {
    options = {
      addonPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Nix packages providing the addons for this WoW flavour.";
      };

      developmentAddons = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        example = {
          MyAddon = "/home/user/src/MyAddon";
        };
        description = ''
          Addons to link directly from local source directories while developing.
          Attribute names are the addon directory names; paths are expanded by
          the activation script, so $HOME may be used.
        '';
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

      addonDir = lib.mkOption {
        type = lib.types.str;
        default = defaultAddonDir;
        description = "Path to this version's Interface/AddOns directory.";
        example = ".local/share/wineprefixes/battlenet-wow/pfx/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns";
      };

      wtfDir = lib.mkOption {
        type = lib.types.str;
        default = defaultWtfDir;
        description = "Path to this version's WTF directory.";
        example = ".local/share/wineprefixes/battlenet-wow/pfx/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF";
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
      default = inputs.proton-ge-nix.packages.${pkgs.stdenv.hostPlatform.system}.v11.steamcompattool;
      description = "Proton package used to run World of Warcraft.";
    };

    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to run Wine with its native Wayland driver instead of Xwayland.";
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
