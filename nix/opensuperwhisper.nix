{
  config,
  pkgs,
  lib,
  ...
}:

let
  app = pkgs.stdenv.mkDerivation {
    pname = "opensuperwhisper";
    version = "latest";

    src = pkgs.fetchurl {
      url = "https://github.com/Starmel/OpenSuperWhisper/releases/latest/download/OpenSuperWhisper.dmg";
      hash = "sha256-r1ylFCwi5b7Tun0mQiI8CkgeSZNfWlps8bx2bH7NnWk=";
    };

    sourceRoot = "OpenSuperWhisper.app";

    nativeBuildInputs = [ pkgs.undmg ];

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
      license = pkgs.lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
    };
  };
in
{
  home.activation.installOpenSuperWhisper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    src="${app}/Applications/OpenSuperWhisper.app"
    dst="$HOME/Applications/OpenSuperWhisper.app"
    marker="$HOME/Applications/.opensuperwhisper.nix-source"
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

  launchd.agents.opensuperwhisper = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "${config.home.homeDirectory}/Applications/OpenSuperWhisper.app"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Interactive";
    };
  };
}
