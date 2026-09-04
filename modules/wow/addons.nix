{pkgs}: {
  githubAddon = {
    name ? repo,
    owner,
    repo,
    rev,
    hash,
  }:
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      version = pkgs.lib.strings.removePrefix "v" rev;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev;
        sha256 = hash;
      };
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        mkdir -p "$out/${name}"
        cp -R . "$out/${name}/"
      '';
    };

  githubReleaseAddon = {
    name,
    owner,
    repo,
    rev,
    asset,
    sha256,
    subdir,
  }:
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      version = pkgs.lib.strings.removePrefix "v" rev;
      src = pkgs.fetchurl {
        url = "https://github.com/${owner}/${repo}/releases/download/${rev}/${asset}";
        inherit sha256;
      };
      nativeBuildInputs = [pkgs.unzip];
      dontUnpack = true;
      installPhase = ''
        mkdir -p "$out" "$TMPDIR/unpacked"
        unzip -q "$src" -d "$TMPDIR/unpacked"
        mkdir -p "$out/${subdir}"
        cp -R "$TMPDIR/unpacked/${subdir}/." "$out/${subdir}/"
      '';
    };

  zipAddon = {
    name,
    url,
    sha256,
    version,
  }:
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      inherit version;
      src = pkgs.fetchurl {
        inherit url sha256;
        name = "wow-addon-${name}.zip";
      };
      nativeBuildInputs = [pkgs.unzip];
      dontUnpack = true;
      installPhase = ''
        mkdir -p "$out"
        unzip -q "$src" -d "$out"
      '';
    };

  svnAddon = {
    name,
    url,
    rev,
    sha256,
    target,
  }:
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      version = pkgs.lib.strings.removePrefix "v" rev;
      src = pkgs.fetchsvn {inherit url rev sha256;};
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        mkdir -p "$out"
        cp -R -L . "$out/${target}"
      '';
    };
}
