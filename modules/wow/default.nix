{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.wow;

  wineGraphicsDriver =
    if cfg.wayland
    then "wayland"
    else "x11";

  winePrefixDir =
    if lib.hasPrefix "/" cfg.prefixDir
    then cfg.prefixDir
    else "$HOME/${cfg.prefixDir}";

  uiLayoutAddon = pkgs.callPackage ../../pkgs/home-manager-wow-ui-layout {
    layoutName = cfg.uiLayoutName;
    layoutFallback = cfg.uiLayoutFallback;
  };

  flavourExeMap = {
    retail = "Wow.exe";
    beta = "WowB.exe";
    classic = "WowClassic.exe";
    classic-era = "WowClassic.exe";
    ptr = "WowT.exe";
    xptr = "WowT.exe";
  };

  gitignoreFile = pkgs.writeText "wow-wtf-gitignore" (
    lib.concatStringsSep "\n" (["/*"] ++ map (p: "!/${p}") cfg.wtfSync.syncPaths) + "\n"
  );

  wtfSyncInvocations = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: version: ''
      sync_version "${name}" "${version.wtfDir}"
    '')
    cfg.versions);

  wowWtfSyncScript = pkgs.writeShellApplication {
    name = "wow-wtf-sync";
    runtimeInputs = [pkgs.git] ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.libnotify;
    text = ''
      pull_only=false
      case "''${1:-}" in
        "") ;;
        --pull-only) pull_only=true ;;
        *)
          echo "Usage: wow-wtf-sync [--pull-only]" >&2
          exit 2
          ;;
      esac

      notify_failure() {
        if command -v notify-send >/dev/null 2>&1; then
          notify-send --app-name="World of Warcraft" --app-icon=wow --urgency=critical "WoW WTF sync failed" "$1"
        fi
      }

      sync_version() {
        version="$1"
        WTF_DIR="$2"
        if [[ "$WTF_DIR" != /* ]]; then
          WTF_DIR="$HOME/$WTF_DIR"
        fi

        if [ ! -d "$WTF_DIR" ]; then
          echo "WoW $version WTF directory not found: $WTF_DIR"
          return 1
        fi

        cd "$WTF_DIR"

        if [ ! -d .git ]; then
          git init --object-format=sha256 -b ${cfg.wtfSync.branch}
          git remote add origin "${cfg.wtfSync.remoteUrl}"
        fi

        if [ ! -f .gitignore ]; then
          cp ${gitignoreFile} .gitignore
          git add .gitignore
          git commit -m "Add .gitignore"
        fi

        if ! git fetch origin ${cfg.wtfSync.branch}; then
          notify_failure "Could not fetch $version branch ${cfg.wtfSync.branch}."
          return 1
        fi
        if git rev-parse --verify origin/${cfg.wtfSync.branch} &>/dev/null; then
          if ! git rebase --autostash origin/${cfg.wtfSync.branch}; then
            notify_failure "A merge conflict needs resolving in $WTF_DIR. Run wow-wtf-resolve."
            return 1
          fi
        fi

        if [ "$pull_only" = true ]; then
          return 0
        fi

        git add -A
        if ! git diff --staged --quiet; then
          git commit -m "WTF sync from $version on $(hostname) at $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
        fi
        if [ "$(git rev-list --count origin/${cfg.wtfSync.branch}..HEAD)" -gt 0 ]; then
          git push -u origin ${cfg.wtfSync.branch}
        fi
      }

      ${wtfSyncInvocations}
    '';
  };

  wowWtfResolveScript = pkgs.writeShellApplication {
    name = "wow-wtf-resolve";
    runtimeInputs = [pkgs.git pkgs.meld] ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.libnotify;
    text = ''
      notify_failure() {
        if command -v notify-send >/dev/null 2>&1; then
          notify-send --app-name="World of Warcraft" --app-icon=wow --urgency=critical "WoW WTF conflict resolution failed" "$1"
        fi
      }

      resolve_version() {
        version="$1"
        WTF_DIR="$2"
        if [[ "$WTF_DIR" != /* ]]; then
          WTF_DIR="$HOME/$WTF_DIR"
        fi
        if [ ! -d "$WTF_DIR/.git" ]; then
          return 0
        fi

        cd "$WTF_DIR"
        if ! git rev-parse --verify REBASE_HEAD >/dev/null 2>&1; then
          return 0
        fi

        git mergetool --tool=meld --no-prompt
        if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
          notify_failure "Unresolved files remain in $WTF_DIR."
          return 1
        fi

        git add -A
        if ! GIT_EDITOR=true git rebase --continue; then
          notify_failure "The $version rebase could not be continued in $WTF_DIR."
          return 1
        fi

        echo "WoW $version WTF conflict resolved."
      }

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: version: ''
          resolve_version "${name}" "${version.wtfDir}"
        '')
        cfg.versions)}
    '';
  };

  wowWtfWatcherScript = pkgs.writeShellApplication {
    name = "wow-wtf-watcher";
    runtimeInputs = lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.procps;
    text = ''
      while true; do
        until pgrep -f '${cfg.wtfSync.processPattern}' > /dev/null 2>&1; do
          sleep 10
        done

        echo "WoW started, monitoring for exit..."
        pid=$(pgrep -f '${cfg.wtfSync.processPattern}')
        echo "Enabling gamemode for $pid"
        gamemoded --request="$pid"

        while pgrep -f '${cfg.wtfSync.processPattern}' > /dev/null 2>&1; do
          sleep 10
        done

        echo "WoW exited, waiting 30s for file writes to finish..."
        sleep 30

        echo "Starting WTF sync..."
        ${wowWtfSyncScript}/bin/wow-wtf-sync && echo "WTF sync complete" || echo "WTF sync failed"
      done
    '';
  };

  versionStates =
    lib.mapAttrs (flavour: wowConfig: let
      flavourDirName = "_${builtins.replaceStrings ["-"] ["_"] flavour}_";
      gameDir = "${cfg.wowDir}/${flavourDirName}";
    in {
      addonInstallDir = wowConfig.addonDir;
      developmentAddons = wowConfig.developmentAddons;
      addonsEnv = pkgs.runCommand "wow-addons-${flavour}" {} ''
        mkdir "$out"
        ${lib.concatMapStringsSep "\n" (addon: ''
            for addon_entry in ${addon}/*; do
              ln -s "$addon_entry" "$out/$(basename "$addon_entry")"
            done
          '')
          (wowConfig.addonPackages ++ [uiLayoutAddon])}
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (addon: source: ''
            ln -s "${source}" "$out/${addon}"
          '')
          wowConfig.developmentAddons)}
      '';
      mutableAddOns = wowConfig.mutableAddOns;
      executable =
        if wowConfig.executable != null
        then wowConfig.executable
        else "${gameDir}/${flavourExeMap.${flavour} or "Wow.exe"}";
    })
    cfg.versions;
in {
  imports = [
    ./options.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) (let
      prefix = winePrefixDir;
      protonTool = cfg.protonPackage;
      steamRuntimeLookup = ''
        steam_runtime="''${STEAM_RUNTIME_ENTRY_POINT:-$HOME/.local/share/Steam/steamapps/common/SteamLinuxRuntime_4/_v2-entry-point}"
        if [ ! -x "$steam_runtime" ]; then
          echo "SteamLinuxRuntime_4 was not found: $steam_runtime" >&2
          echo "Install Steam Linux Runtime 4 from Steam's Tools section, then retry." >&2
          exit 1
        fi
      '';
      protonEnvironment = appId: ''
        export STEAM_COMPAT_CLIENT_INSTALL_PATH="''${STEAM_COMPAT_CLIENT_INSTALL_PATH:-$HOME/.local/share/Steam}"
        export STEAM_COMPAT_DATA_PATH="${prefix}"
        export SteamAppId="''${SteamAppId:-${appId}}"
        export SteamGameId="''${SteamGameId:-${appId}}"
        export STEAM_COMPAT_APP_ID="$SteamAppId"
        export PROTON_NO_ESYNC=1
        export PROTON_NO_FSYNC=1
        export WINE_SIMULATE_WRITECOPY=1
        ${lib.optionalString cfg.wayland ''
          # Prefer Wine's native Wayland driver over Xwayland.  WAYLAND_DISPLAY
          # and XDG_RUNTIME_DIR remain inherited from the graphical session.
          export DISPLAY=""
        ''}
      '';
      protonInit = pkgs.writeShellApplication {
        name = "wow-proton-init";
        runtimeInputs = [pkgs.steam-run];
        text = ''
          ${steamRuntimeLookup}
          ${protonEnvironment cfg.battleNetAppId}
          mkdir -p "$STEAM_COMPAT_DATA_PATH"
          steam-run "$steam_runtime" --verb=run -- "${protonTool}/proton" run wineboot -u
          steam-run "$steam_runtime" --verb=run -- "${protonTool}/proton" run \
            reg.exe add 'HKCU\Software\Wine\Drivers' /v Graphics /d ${wineGraphicsDriver} /f
          echo "Proton prefix ready: $STEAM_COMPAT_DATA_PATH/pfx"
        '';
      };
      protonInstall = pkgs.writeShellApplication {
        name = "wow-battlenet-install";
        runtimeInputs = [pkgs.curl pkgs.steam-run];
        text = ''
          ${steamRuntimeLookup}
          ${protonEnvironment cfg.battleNetAppId}
          installer="''${1:-$HOME/Downloads/Battle.net-Setup.exe}"
          if [ "$installer" = "--download" ]; then
            installer="$(mktemp -d)/Battle.net-Setup.exe"
            mkdir -p "$(dirname "$installer")"
            curl -L --fail --output "$installer" \
              "https://downloader.battle.net//download/getInstallerForGame?os=win&gameProgram=BATTLENET_APP&version=Live"
          fi
          if [ ! -f "$installer" ]; then
            echo "Usage: wow-battlenet-install [--download|/path/to/Battle.net-Setup.exe]" >&2
            exit 2
          fi
          install_dir="$(dirname "$installer")"
          export STEAM_COMPAT_INSTALL_PATH="$install_dir"
          ${protonInit}/bin/wow-proton-init
          steam-run "$steam_runtime" --verb=waitforexitandrun -- "${protonTool}/proton" waitforexitandrun "$installer"
        '';
      };
      protonRun = {
        name,
        executable,
        appId,
        useGamemode ? false,
        dxvkHud ? null,
      }:
        pkgs.writeShellApplication {
          inherit name;
          runtimeInputs = [pkgs.steam-run] ++ lib.optional (useGamemode && pkgs.stdenv.hostPlatform.isLinux) pkgs.gamemode;
          text = ''
            ${steamRuntimeLookup}
            ${protonEnvironment appId}
            ${lib.optionalString (dxvkHud != null) ''
              export DXVK_HUD="${dxvkHud}"
            ''}
            exe="$STEAM_COMPAT_DATA_PATH/${executable}"
            if [ ! -f "$exe" ]; then
              echo "Executable not found: $exe" >&2
              echo "Run wow-battlenet-install first, then install the game in Battle.net." >&2
              exit 1
            fi
            install_dir="$(dirname "$exe")"
            export STEAM_COMPAT_INSTALL_PATH="$install_dir"
            run_prefix=()
            ${lib.optionalString useGamemode ''
              if command -v gamemoderun >/dev/null 2>&1; then
                run_prefix=(gamemoderun)
              fi
            ''}
            "''${run_prefix[@]}" steam-run "$steam_runtime" --verb=waitforexitandrun -- "${protonTool}/proton" waitforexitandrun "$exe" "$@"
          '';
        };
      battleNet = protonRun {
        name = "wow-battlenet";
        executable = cfg.battleNetExe;
        appId = cfg.battleNetAppId;
        useGamemode = false;
        dxvkHud = "0";
      };
      versionLaunchers = lib.mapAttrsToList (name: version:
        protonRun {
          name = "wow-${name}";
          executable = versionStates.${name}.executable;
          appId = cfg.wowAppId;
          useGamemode = true;
          dxvkHud = "0";
        })
      cfg.versions;
    in {
      home.packages = [protonInit protonInstall battleNet] ++ versionLaunchers;
      xdg.desktopEntries =
        {
          bnet = {
            name = "Battle.net";
            comment = "Battle.net via Proton in a manually managed prefix";
            exec = "wow-battlenet --disable-gpu";
            icon = "com.blizzard.battlenet";
            type = "Application";
            categories = ["Game"];
            settings.StartupWMClass = "battle.net.exe";
          };
        }
        // lib.optionalAttrs (!cfg.hideDesktopEntries) (
          lib.mapAttrs' (name: version:
            lib.nameValuePair "wow-${name}" {
              name = version.displayName;
              comment = "${version.displayName} via Proton in a manually managed prefix";
              exec = "wow-${name}";
              icon = "com.blizzard.worldofwarcraft";
              type = "Application";
              categories = ["Game"];
              settings.StartupWMClass = lib.toLower flavourExeMap.${name};
            })
          cfg.versions
        );

      xdg.dataFile."icons/hicolor/scalable/apps/com.blizzard.worldofwarcraft.svg".source = ./icons/wow.svg;
      xdg.dataFile."icons/hicolor/symbolic/apps/com.blizzard.worldofwarcraft-symbolic.svg".source = ./icons/wow-symbolic.svg;
      xdg.dataFile."icons/hicolor/symbolic/apps/com.blizzard.battlenet-symbolic.svg".source = ./icons/battlenet.svg;
      xdg.dataFile."icons/hicolor/16x16/apps/com.blizzard.battlenet.png".source = ./icons/bnet_16.png;
      xdg.dataFile."icons/hicolor/32x32/apps/com.blizzard.battlenet.png".source = ./icons/bnet_32.png;
      xdg.dataFile."icons/hicolor/48x48/apps/com.blizzard.battlenet.png".source = ./icons/bnet_48.png;
      xdg.dataFile."icons/hicolor/128x128/apps/com.blizzard.battlenet.png".source = ./icons/bnet_128.png;
    }))

    (lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.wtfSync.enable [wowWtfResolveScript];
      home.activation.wowAddons = lib.mkIf (cfg.versions != {}) (lib.hm.dag.entryAfter ["writeBoundary"] (
        lib.concatStringsSep "\n" (lib.mapAttrsToList (name: version:
          if version.mutableAddOns
          then ''
            addon_install_dir="${version.addonInstallDir}"

            if [ -L "$addon_install_dir" ]; then
              $DRY_RUN_CMD unlink "$addon_install_dir"
            fi
            $DRY_RUN_CMD mkdir -p "$addon_install_dir"

            # Drop symlinks from previous generations so removed addons disappear.
            for link in "$addon_install_dir"/*; do
              if [ -L "$link" ] && [[ "$(readlink "$link")" == /nix/store/* ]]; then
                $DRY_RUN_CMD rm "$link"
              fi
            done

            for addon in ${version.addonsEnv}/*; do
              target="$addon_install_dir/$(basename "$addon")"
              # Replace addon folders previously installed imperatively.
              if [ -e "$target" ] && [ ! -L "$target" ]; then
                $DRY_RUN_CMD rm -rf "$target"
              fi
              $DRY_RUN_CMD ln -sfn "$(readlink -f "$addon")" "$target"
            done

          ''
          else ''
            if [ -d "${version.addonInstallDir}" ] && [ ! -L "${version.addonInstallDir}" ]; then
              if [ -n "$(find "${version.addonInstallDir}" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
                echo "WoW ${name} AddOns directory already exists but is configured as immutable: ${version.addonInstallDir}" >&2
                echo "Remove it or set programs.wow.versions.${name}.mutableAddOns = true." >&2
                exit 1
              else
                $DRY_RUN_CMD rm -d "${version.addonInstallDir}"
              fi
            fi
            ln -sfn "${version.addonsEnv}" "${version.addonInstallDir}"
          '')
        versionStates)
      ));
    })

    (lib.mkIf (cfg.enable && cfg.wtfSync.enable) {
      assertions = [
        {
          assertion = cfg.wtfSync.remoteUrl != "";
          message = "programs.wow.wtfSync.remoteUrl must be set when wtfSync.enable is true";
        }
      ];
    })

    (lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
      assertions = [
        {
          assertion = cfg.protonPackage != null;
          message = "programs.wow.protonPackage must be set when programs.wow is enabled on Linux";
        }
      ];
    })

    (lib.mkIf (cfg.enable && cfg.wtfSync.enable && pkgs.stdenv.hostPlatform.isLinux) {
      systemd.user.services.wow-wtf-pull = {
        Unit = {
          Description = "Pull WoW WTF configuration on login";
          Wants = ["network-online.target"];
          After = ["network-online.target"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${wowWtfSyncScript}/bin/wow-wtf-sync --pull-only";
        };
        Install.WantedBy = ["default.target"];
      };

      systemd.user.services.wow-wtf-watcher = {
        Unit.Description = "Watch for WoW process and sync WTF to git on exit";
        Service = {
          Type = "simple";
          ExecStart = "${wowWtfWatcherScript}/bin/wow-wtf-watcher";
          Restart = "on-failure";
          RestartSec = "30s";
        };
        Install.WantedBy = ["default.target"];
      };
    })

    (lib.mkIf (cfg.enable && cfg.wtfSync.enable && pkgs.stdenv.hostPlatform.isDarwin) {
      launchd.agents.wow-wtf-pull = {
        enable = true;
        config = {
          Label = "dev.racc.wow-wtf-pull";
          ProgramArguments = ["${wowWtfSyncScript}/bin/wow-wtf-sync" "--pull-only"];
          RunAtLoad = true;
          StandardOutPath = "/tmp/wow-wtf-pull.log";
          StandardErrorPath = "/tmp/wow-wtf-pull.log";
        };
      };

      launchd.agents.wow-wtf-watcher = {
        enable = true;
        config = {
          Label = "dev.racc.wow-wtf-watcher";
          ProgramArguments = ["${wowWtfWatcherScript}/bin/wow-wtf-watcher"];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/tmp/wow-wtf-watcher.log";
          StandardErrorPath = "/tmp/wow-wtf-watcher.log";
        };
      };
    })
  ];
}
