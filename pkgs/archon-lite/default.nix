{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  unzip,
}: let
  pname = "archon-lite";
  version = "9.6.80";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/download/v${version}/archon-lite-v${version}.${
      if stdenvNoCC.hostPlatform.isDarwin
      then "zip"
      else "AppImage"
    }";
    hash =
      if stdenvNoCC.hostPlatform.isDarwin
      then "sha256-ayKrhgr62FVVd0eoFYcida9HQFrQDzKlmDe7l9pLg+8="
      else "sha512-AXxSff3GwfHC2/jCVYPLzltMNwMZPM2EF7/oafTvwQbfcduL21bHIs4v5THPkKlP70tmjfV+Dlv2rJcCSEmQwQ==";
  };
  meta = {
    description = "Official Warcraft Logs uploader with automatic live logging";
    homepage = "https://www.archon.gg/download";
    license = lib.licenses.unfree;
    mainProgram = pname;
    platforms = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
in
  if stdenvNoCC.hostPlatform.isDarwin
  then
    stdenvNoCC.mkDerivation {
      inherit pname version src meta;
      nativeBuildInputs = [unzip];
      sourceRoot = ".";
      dontBuild = true;
      # Preserve Electron's bundled binaries and their code signatures.
      dontFixup = true;
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/Applications" "$out/bin"
        cp -R "Archon App Lite.app" "$out/Applications/"
        cat > "$out/bin/archon-lite" <<EOF
        #!${stdenvNoCC.shell}
        exec "$out/Applications/Archon App Lite.app/Contents/MacOS/Archon App Lite" "\$@"
        EOF
        chmod +x "$out/bin/archon-lite"
        runHook postInstall
      '';
    }
  else let
    extracted = appimageTools.extractType2 {inherit pname version src;};
  in
    appimageTools.wrapType2 {
      inherit pname version src meta;
      extraInstallCommands = ''
        install -Dm644 ${extracted}/archon-lite.desktop "$out/share/applications/archon-lite.desktop"
        substituteInPlace "$out/share/applications/archon-lite.desktop" \
          --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=archon-lite'
        install -Dm644 ${extracted}/usr/share/icons/hicolor/512x512/apps/archon-lite.png \
          "$out/share/icons/hicolor/512x512/apps/archon-lite.png"
      '';
    }
