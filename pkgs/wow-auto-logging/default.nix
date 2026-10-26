{
  runCommand,
  interfaceVersion,
  lua,
}:
runCommand "wow-auto-logging" {nativeBuildInputs = [lua];} ''
  lua ${./test.lua} ${./NixAutoLogging.lua}
  mkdir -p "$out/NixAutoLogging"
  cat > "$out/NixAutoLogging/NixAutoLogging.toc" <<EOF
  ## Interface: ${toString interfaceVersion}
  ## Title: Nix Auto Logging
  ## Notes: Enables advanced combat logging throughout raids and dungeons.
  NixAutoLogging.lua
  EOF
  cp ${./NixAutoLogging.lua} "$out/NixAutoLogging/NixAutoLogging.lua"
''
