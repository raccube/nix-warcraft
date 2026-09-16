{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "BigWigs";
  version = "424.5";
  src = pkgs.fetchurl {
    url = "https://github.com/BigWigsMods/BigWigs/releases/download/v424.5/BigWigs-v424.5.zip";
    sha256 = "1qqandfq9za03dk7xnrz656pcpzkv8ky48dwmvh19ml0wqyilxlz";
  };
  nativeBuildInputs = [pkgs.unzip];
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out" "$TMPDIR/unpacked"
    unzip -q "$src" -d "$out"
    mkdir -p "$out/"
    cp -R "$TMPDIR/unpacked/" "$out/"
  '';
}
