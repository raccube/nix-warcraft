{
  lib,
  stdenv,
  fetchgit,
  cmake,
}:
stdenv.mkDerivation {
  pname = "mpqcli";
  version = "0.11.0";

  src = fetchgit {
    url = "https://github.com/thegraydot/mpqcli.git";
    rev = "f23ee4ce4727661df30ec0a52c6f80ccb1bfb3c4";
    hash = "sha256-MH6+9C/XnDRxZvtzAumVhDfSwGKYEzayYRWQo7HMkhg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [cmake];

  installPhase = ''
    install -Dm755 bin/mpqcli "$out/bin/mpqcli"
  '';

  meta = {
    description = "Command-line tool for manipulating MPQ archives";
    homepage = "https://github.com/thegraydot/mpqcli";
    license = lib.licenses.mit;
    mainProgram = "mpqcli";
    platforms = lib.platforms.unix;
  };
}
