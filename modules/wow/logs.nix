{
  config,
  lib,
  pkgs,
  ...
}: let
  wow = config.programs.wow;
  cfg = wow.logs;
  version = wow.versions.${cfg.version} or null;
  uploader = pkgs.writeShellApplication {
    name = "wow-log-uploader";
    text = ''
      logs_dir=${lib.escapeShellArg cfg.directory}
      if [[ "$logs_dir" != /* ]]; then
        logs_dir="$HOME/$logs_dir"
      fi
      mkdir -p "$logs_dir"
      exec ${lib.getExe cfg.package} \
        --operation-name liveLog \
        --directory-path "$logs_dir" \
        --report-description ${lib.escapeShellArg cfg.description} \
        --report-visibility ${toString ({
          public = 0;
          private = 1;
          unlisted = 2;
        }.${
          cfg.visibility
        })} \
        --region ${toString cfg.region} \
        --include-entire-file-in-report false \
        --enable-real-time-uploading false \
        ${lib.optionalString (cfg.guildId != null) "--guild ${toString cfg.guildId}"} "$@"
    '';
  };
in {
  options.programs.wow.logs = {
    enable = lib.mkEnableOption "automatic Warcraft Logs uploads after each encounter using Archon Lite";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../../pkgs/archon-lite {};
      description = "Archon Lite package supporting the liveLog command-line operation. Requires allowing the unfree archon-lite package.";
    };
    version = lib.mkOption {
      type = lib.types.str;
      default = "retail";
      description = "Configured WoW version whose combat logs to upload.";
    };
    directory = lib.mkOption {
      type = lib.types.str;
      default =
        if version == null
        then ""
        else "${builtins.dirOf (builtins.dirOf version.addonDir)}/Logs";
      description = "Combat log directory. Relative paths resolve against the home directory.";
    };
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start the uploader with the graphical desktop session. Sign in once using the uploader UI.";
    };
    visibility = lib.mkOption {
      type = lib.types.enum ["public" "private" "unlisted"];
      default = "unlisted";
      description = "Visibility of uploaded reports.";
    };
    region = lib.mkOption {
      type = lib.types.enum [1 2 3 4 5];
      default = 2;
      description = "Warcraft Logs region: US=1, EU=2, KR=3, TW=4, CN=5.";
    };
    guildId = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = "Guild to upload to. When null, uses the destination saved in Archon Lite; select Personal Logs there for personal reports.";
    };
    description = lib.mkOption {
      type = lib.types.str;
      default = "WoW live log";
      description = "Description of the live report.";
    };
    autoCombatLogging = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install an addon enabling advanced combat logging for the entire time spent in raid and dungeon instances.";
    };
    interfaceVersion = lib.mkOption {
      type = lib.types.ints.positive;
      default = 120105;
      description = "TOC interface version for the auto logging addon. Set this to match the selected game flavour.";
    };
  };

  config = lib.mkIf (wow.enable && cfg.enable) (lib.mkMerge [
    {
      assertions = [
        {
          assertion = version != null;
          message = "programs.wow.logs.version must name a configured programs.wow.versions entry.";
        }
        {
          assertion = cfg.directory != "";
          message = "programs.wow.logs.directory must not be empty.";
        }
      ];
      home.packages = [cfg.package uploader];
    }
    (lib.mkIf (cfg.autoStart && pkgs.stdenv.hostPlatform.isLinux) {
      systemd.user.services.wow-log-uploader = {
        Unit = {
          Description = "Warcraft Logs encounter uploader";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${uploader}/bin/wow-log-uploader";
          Restart = "on-failure";
          RestartSec = 10;
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    })
    (lib.mkIf (cfg.autoStart && pkgs.stdenv.hostPlatform.isDarwin) {
      launchd.agents.wow-log-uploader = {
        enable = true;
        config = {
          ProgramArguments = ["${uploader}/bin/wow-log-uploader"];
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
          LimitLoadToSessionType = "Aqua";
          ThrottleInterval = 10;
        };
      };
    })
  ]);
}
