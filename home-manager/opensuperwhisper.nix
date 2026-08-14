{
  lib,
  undmg,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "opensuperwhisper";
  version = "latest";

  src = builtins.fetchurl "https://github.com/Starmel/OpenSuperWhisper/releases/latest/download/OpenSuperWhisper.dmg";

  sourceRoot = "OpenSuperWhisper.app";

  nativeBuildInputs = [ undmg ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/OpenSuperWhisper.app"
    cp -R . "$out/Applications/OpenSuperWhisper.app"

    runHook postInstall
  '';

  meta = {
    description = "macOS dictation app";
    homepage = "https://github.com/Starmel/OpenSuperWhisper";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    maintainers = [ ];
  };
}
