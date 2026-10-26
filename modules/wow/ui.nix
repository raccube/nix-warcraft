{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.wow.ui;
  optional = type: description:
    lib.mkOption {
      type = lib.types.nullOr type;
      default = null;
      inherit description;
    };
in {
  options.programs.wow.ui = {
    enable = lib.mkEnableOption "declarative Retail WoW UI settings on every character";
    interfaceVersion = lib.mkOption {
      type = lib.types.ints.positive;
      default = 120100;
      description = "Retail TOC interface version; update when the client marks the addon outdated.";
    };
    cvars = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {autoLootDefault = "1";};
      description = "Client CVars applied on login and reload. Values are strings.";
    };
    chatFrames = lib.mkOption {
      default = {};
      description = "Settings for existing chat frame slots (1 through 10). Omitted fields are unmanaged. Slot 1 is General and slot 2 is the combat log. This does not create or open tabs.";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = optional lib.types.str "Chat tab name.";
          fontSize = optional (lib.types.ints.between 6 32) "Chat font size.";
          fading = optional lib.types.bool "Whether old messages fade out.";
          alpha = optional (lib.types.numbers.between 0 1) "Chat background opacity.";
          messageGroups = optional (lib.types.listOf lib.types.str) "Replacement message groups, such as SAY, GUILD, or WHISPER. An empty list removes all groups; channels are managed separately by the game.";
        };
      });
    };
  };

  config = lib.mkIf (config.programs.wow.enable && cfg.enable) {
    assertions = [
      {
        assertion = lib.all (name: builtins.match "([1-9]|10)" name != null) (builtins.attrNames cfg.chatFrames);
        message = "programs.wow.ui.chatFrames keys must be chat frame slots 1 through 10.";
      }
    ];
    programs.wow.versions.retail.addonPackages = [
      (pkgs.callPackage ../pkgs/wow-ui-settings {
        inherit (cfg) interfaceVersion;
        settings = {inherit (cfg) cvars chatFrames;};
      })
    ];
  };
}
