{
  lib,
  runCommand,
  writeText,
  lua,
  interfaceVersion,
  settings,
}: let
  configuration = writeText "Settings.lua" ''
    local _, addon = ...
    addon.settings = ${lib.generators.toLua {} settings}
  '';
in
  runCommand "wow-ui-settings" {nativeBuildInputs = [lua];} ''
      mkdir -p "$out/HMUISettings"
      cp ${configuration} "$out/HMUISettings/Settings.lua"
      cp ${./UI.lua} "$out/HMUISettings/UI.lua"
      cat > "$out/HMUISettings/HMUISettings.toc" <<'EOF'
      ## Interface: ${toString interfaceVersion}
      ## Title: Home Manager UI Settings
      ## Notes: Applies declarative UI settings on every character
      ## Version: 1.0
      Settings.lua
      UI.lua
      EOF
      luac -p "$out/HMUISettings/Settings.lua"
    luac -p "$out/HMUISettings/UI.lua"
    lua ${./test.lua} "$out/HMUISettings/UI.lua"
  ''
