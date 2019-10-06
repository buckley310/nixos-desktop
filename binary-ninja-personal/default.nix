{ stdenv, autoPatchelfHook, requireFile, libxkbcommon, makeWrapper, unzip, zlib, glib, fontconfig, freetype, dbus, python27, libglvnd, libXext, libX11, libXrender, libXi, libSM, libICE, xkeyboardconfig }:
stdenv.mkDerivation rec {
    name = "binary-ninja-personal";

    src = requireFile {
      name = "BinaryNinja-personal.zip";
      url = "file:///var/BinaryNinja-personal.zip";
      sha256 = "5686759920230d64e1fe71d4b2b608dd28c9faba58de5af242b64405186c6be3";
    };

    nativeBuildInputs = [ autoPatchelfHook libxkbcommon stdenv.cc.cc.lib zlib glib fontconfig freetype dbus python27 libglvnd libXext libX11 libXrender libXi libSM libICE unzip makeWrapper ];

    dontStrip = true;
    dontPatchELF = true;

    installPhase = ''
        mkdir -p $out/lib $out/bin
        mv $NIX_BUILD_TOP/$sourceRoot $out/lib/binary-ninja
        ln -s "${python27}/lib/libpython2.7.so" "$out/lib/binary-ninja/libpython2.7.so.1"
        makeWrapper $out/lib/binary-ninja/binaryninja $out/bin/binaryninja \
            --set QT_XKB_CONFIG_ROOT "${xkeyboardconfig}/share/X11/xkb" \
            --set QTCOMPOSE "${libX11.out}/share/X11/locale"
    '';
}
