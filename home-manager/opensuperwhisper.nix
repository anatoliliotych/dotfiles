{
  lib,
  fetchurl,
  undmg,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "opensuperwhisper";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/Starmel/OpenSuperWhisper/releases/latest/download/OpenSuperWhisper.dmg";
    hash = "sha256-r1ylFCwi5b7Tun0mQiI8CkgeSZNfWlps8bx2bH7NnWk=";
  };

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
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
