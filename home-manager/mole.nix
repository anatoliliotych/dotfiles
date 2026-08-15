{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "mole";
  version = "1.50.0";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    rev = "V${version}";
    hash = "sha256-OM5OluR5PDQFIKpjPPhkooPNlDNisjhjfMU9yGIxAg8=";
  };

  vendorHash = "sha256-Q7VzGJ1bGAyMi2Ih3LvI92lCVqxKIyr7H89LAFczNbo=";

  subPackages = [ "cmd/analyze" "cmd/status" ];

  doCheck = false;

  ldflags = [
    "-X"
    "main.Version=${version}"
    "-X"
    "main.BuildTime=unknown"
  ];

  postInstall = ''
    mkdir -p "$out/libexec/bin"
    mv "$out/bin/analyze" "$out/libexec/bin/analyze-go"
    mv "$out/bin/status" "$out/libexec/bin/status-go"
    cp -R "$src/bin/." "$out/libexec/bin/"
    cp -R "$src/lib" "$out/libexec/lib"

    install -Dm755 "$src/mole" "$out/bin/mole"
    sed -i -e "s|^SCRIPT_DIR=.*|SCRIPT_DIR='$out/libexec'|" "$out/bin/mole"
    ln -s "$out/bin/mole" "$out/bin/mo"
  '';

  meta = {
    description = "Deep clean and optimize your Mac from the terminal";
    homepage = "https://mole.fit";
    license = lib.licenses.gpl3Plus;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "mole";
  };
}
