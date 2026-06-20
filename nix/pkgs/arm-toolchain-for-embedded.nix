{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  xar,
  gzip,
  cpio,
}:

stdenvNoCC.mkDerivation rec {
  pname = "arm-toolchain-for-embedded";
  version = "22.1.0";

  src = fetchurl {
    url = "https://github.com/arm/arm-toolchain/releases/download/release-${version}-ATfE/ATfE-${version}-Darwin-universal.dmg";
    hash = "sha256-WZWDFkizG39ckGSp3iDn/GKQE90f+iQroDfGRcROTeU=";
  };

  nativeBuildInputs = [
    undmg
    xar
    gzip
    cpio
  ];

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/opt/${pname}"

    payloadRoot="$TMPDIR/${pname}-payload"
    mkdir -p "$payloadRoot"

    if [ -n "$(find . -maxdepth 2 -name "*.pkg" -type f -print -quit)" ]; then
      find . -maxdepth 2 -name "*.pkg" -type f -print0 | while IFS= read -r -d "" pkg; do
        pkgAbs="$(pwd)/$pkg"
        pkgRoot="$TMPDIR/$(basename "$pkg").contents"
        mkdir -p "$pkgRoot"
        (
          cd "$pkgRoot"
          xar -xf "$pkgAbs"
          find . -name Payload -type f -print | while read -r payload; do
            (cd "$payloadRoot" && gzip -dc "$pkgRoot/$payload" | cpio -idm)
          done
        )
      done
      cp -R "$payloadRoot"/. "$out/opt/${pname}/"
    else
      cp -R . "$out/opt/${pname}/"
    fi

    find "$out/opt/${pname}" -path "*/bin/*" -type f -perm -111 -print | while read -r exe; do
      ln -sf "$exe" "$out/bin/$(basename "$exe")"
    done

    runHook postInstall
  '';

  meta = {
    description = "Arm Toolchain for Embedded";
    homepage = "https://github.com/arm/arm-toolchain";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
