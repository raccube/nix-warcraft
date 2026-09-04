{
  pkgs,
  layoutName,
  layoutFallback,
}: let
  lua = pkgs.writeText "HMUILayout.lua" (
    builtins.replaceStrings
    ["@LAYOUT_NAME@" "@LAYOUT_FALLBACK@"]
    [layoutName layoutFallback]
    (builtins.readFile ./HMUILayout.lua)
  );
in
  pkgs.runCommand "home-manager-wow-ui-layout" {
    nativeBuildInputs = [pkgs.imagemagick];
  } ''
    mkdir -p "$out/HMUILayout"
    cp ${./HMUILayout.toc} "$out/HMUILayout/HMUILayout.toc"
    cp ${lua} "$out/HMUILayout/HMUILayout.lua"
    magick -background none \
      ${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg \
      "$out/HMUILayout/nix-snowflake.tga"
  ''
