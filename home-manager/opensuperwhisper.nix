{
  lib,
  fetchurl,
  undmg,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "opensuperwhisper";
  version = "latest";

  # Hash-pinned "latest" URL: when upstream ships a new release the build
  # fails with a hash mismatch; copy the "got" hash from the error here.
  # Update check without building:
  #   nix store prefetch-file --json <url> | jq .hash
  src = fetchurl {
    url = "https://github.com/Starmel/OpenSuperWhisper/releases/latest/download/OpenSuperWhisper.dmg";
    hash = "sha256-r1ylFCwi5b7Tun0mQiI8CkgeSZNfWlps8bx2bH7NnWk=";
  };

  sourceRoot = "OpenSuperWhisper.app";

  nativeBuildInputs = [ undmg ];

  # Preserve the app bundle code signature.
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
