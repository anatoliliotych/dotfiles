{
  config,
  pkgs,
  lib,
  ...
}:

let
  app = pkgs.stdenv.mkDerivation {
    pname = "orca-slicer";
    version = "2.4.2";

    src = pkgs.fetchurl {
      url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.4.2/OrcaSlicer_Mac_universal_V2.4.2.dmg";
      hash = "sha256-4V57sbZiFOxulrFps4gAQXnE9fcF7/za+MgNSZLuA2Y=";
    };

    sourceRoot = "OrcaSlicer.app";

    nativeBuildInputs = [ pkgs.undmg ];

    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/OrcaSlicer.app"
      cp -R . "$out/Applications/OrcaSlicer.app"

      runHook postInstall
    '';

    meta = {
      description = "Orca Slicer - G-code generator for 3D printers";
      homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
      license = pkgs.lib.licenses.agpl3Plus;
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
    };
  };
in
{
  # Configs (printers, filaments, profiles) live in
  # ~/Library/Application Support/OrcaSlicer and are untouched by the copy.
  home.activation.installOrcaSlicer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    src="${app}/Applications/OrcaSlicer.app"
    dst="$HOME/Applications/OrcaSlicer.app"
    marker="$HOME/Applications/.orca-slicer.nix-source"
    if [[ ! -e "$dst" ]] || [[ "$(cat "$marker" 2>/dev/null)" != "${app}" ]]; then
      # Store copies are read-only, so make leftovers deletable before
      # removing them and keep the fresh copy writable too.
      chmod -R u+w "$dst.new" 2>/dev/null || true
      rm -rf "$dst.new"
      chmod -R u+w "$dst" 2>/dev/null || true
      rm -rf "$dst"
      cp -R "$src" "$dst.new"
      chmod -R u+w "$dst.new"
      mv "$dst.new" "$dst"
      printf '%s' "${app}" > "$marker"
    fi
  '';
}
