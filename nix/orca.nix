{
  config,
  pkgs,
  lib,
  ...
}:

let
  # stdenvNoCC: the phases need only shell, coreutils, and hdiutil, so the
  # clang toolchain would be dead weight (and stdenv churn would force a
  # full re-copy).  The build mounts a DMG via hdiutil, which cannot run
  # in a sandboxed nix build; sandbox is disabled on this machine.
  app = pkgs.stdenvNoCC.mkDerivation {
    pname = "orca-slicer";
    version = "2.4.2";

    src = pkgs.fetchurl {
      url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.4.2/OrcaSlicer_Mac_universal_V2.4.2.dmg";
      hash = "sha256-4V57sbZiFOxulrFps4gAQXnE9fcF7/za+MgNSZLuA2Y=";
    };

    sourceRoot = "OrcaSlicer.app";

    # The DMG is APFS; undmg only supports HFS, so mount it natively.
    unpackPhase = ''
      runHook preUnpack
      mkdir -p "$TMPDIR/orca_mount"
      /usr/bin/hdiutil attach "$src" -mountpoint "$TMPDIR/orca_mount" -nobrowse -readonly -quiet
      cp -R "$TMPDIR/orca_mount/OrcaSlicer.app" .
      /usr/bin/hdiutil detach "$TMPDIR/orca_mount" -quiet
      runHook postUnpack
    '';

    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/OrcaSlicer.app"
      cp -R . "$out/Applications/OrcaSlicer.app"

      # Content signature for the activation-side repair check: the copy
      # is left writable, so a drift check against the store is the only
      # way to notice a modified or corrupted bundle.  Digests are cut
      # before concatenation: shasum output embeds file names, so hashing
      # the raw output would depend on paths that differ between the
      # store and the installed copy.
      sig="$(/usr/bin/shasum -a 256 \
        "$out/Applications/OrcaSlicer.app/Contents/Info.plist" | cut -d' ' -f1)"
      sig+="$(/usr/bin/shasum -a 256 \
        "$out/Applications/OrcaSlicer.app/Contents/MacOS/OrcaSlicer" | cut -d' ' -f1)"
      printf '%s' "$sig" > "$out/signature"

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
  # A pre-existing unmanaged OrcaSlicer.app without a marker is replaced
  # on first activation (the marker only appears once nix manages the app).
  home.activation.installOrcaSlicer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    src="${app}/Applications/OrcaSlicer.app"
    dst="$HOME/Applications/OrcaSlicer.app"
    marker="$HOME/Applications/.orca-slicer.nix-source"
    # The copy is kept writable, so bundle contents can drift: also
    # re-copy when the installed Info.plist/main binary no longer match
    # the store copy, not just when the store path changed.  || true
    # keeps a missing file (set -eu + pipefail) as an empty digest that
    # simply fails the comparison below instead of aborting activation.
    dst_sig="$(/usr/bin/shasum -a 256 "$dst/Contents/Info.plist" 2>/dev/null | cut -d' ' -f1 || true)"
    dst_sig+="$(/usr/bin/shasum -a 256 "$dst/Contents/MacOS/OrcaSlicer" 2>/dev/null | cut -d' ' -f1 || true)"
    if [[ ! -e "$dst" ]] \
      || [[ "$(cat "$marker" 2>/dev/null)" != "${app}" ]] \
      || [[ "$dst_sig" != "$(cat "${app}/signature")" ]]; then
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
