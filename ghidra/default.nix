{ pkgs, stdenv, fetchurl, makeWrapper, adoptopenjdk-bin, unzip }:

stdenv.mkDerivation rec {
    name = "ghidra";
    version = "9.0.4";

    src = fetchurl {
        url = "https://ghidra-sre.org/ghidra_9.0.4_PUBLIC_20190516.zip";
        sha256 = "a50d0cd475d9377332811eeae66e94bdc9e7d88e58477c527e9c6b78caec18bf";
    };

    unpackPhase = ":";

    buildInputs = [ makeWrapper adoptopenjdk-bin unzip ];

    buildPhase = ":";

    installPhase = ''
        (
        set -x
        mkdir -p "$out/bin"
        cd "$out"
        unzip "$src"

        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath '${stdenv.cc.cc.lib}/lib' ./ghidra_${version}/Ghidra/Features/Decompiler/os/linux64/sleigh
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath '${stdenv.cc.cc.lib}/lib' ./ghidra_${version}/Ghidra/Features/Decompiler/os/linux64/decompile
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath '${stdenv.cc.cc.lib}/lib' ./ghidra_${version}/GPL/DemanglerGnu/os/linux64/demangler_gnu
        
        cat <<EOF >"./bin/ghidra"
        #!/bin/sh
        export PATH="\$PATH:${adoptopenjdk-bin}/bin"
        exec "$out/ghidra_${version}/ghidraRun"
        EOF
        chmod +x "./bin/ghidra"
        )
    '';
}

# nix-shell -p 'callPackage ./. {}'
