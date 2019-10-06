{
  stdenv, autoPatchelfHook, requireFile, libxkbcommon, makeWrapper, unzip, zlib, glib,
  fontconfig, freetype, dbus, python37, libglvnd, libXext, libX11, libXrender, libXi,
  libSM, libICE, xkeyboardconfig, nss, libXcomposite, libXcursor, libXdamage, libXtst,
  alsaLib
}:
stdenv.mkDerivation rec {
    name = "binary-ninja-personal";

    src = requireFile {
      name = "BinaryNinja-personal.zip";
      url = "file:///var/BinaryNinja-personal.zip";
      sha256 = "2b6a3bb1183c8ea3e63ea17667dabdf00bff04b304b67c71d8616e47e19188b3";
    };

    nativeBuildInputs = [
      autoPatchelfHook libxkbcommon stdenv.cc.cc.lib zlib glib fontconfig freetype nss
      dbus python37 libglvnd libXext libX11 libXrender libXi libSM libICE unzip makeWrapper
      libXcomposite libXcursor libXdamage libXtst alsaLib
    ];

    dontStrip = true;
    dontPatchELF = true;

    installPhase = ''
        mkdir -p $out/lib $out/bin
        mv $NIX_BUILD_TOP/$sourceRoot $out/lib/binary-ninja
        ln -s "${python37}/lib/libpython3.7m.so.1.0" "$out/lib/binary-ninja/libpython3.7m.so.1"
        makeWrapper $out/lib/binary-ninja/binaryninja $out/bin/binaryninja \
            --set QT_XKB_CONFIG_ROOT "${xkeyboardconfig}/share/X11/xkb" \
            --set QTCOMPOSE "${libX11.out}/share/X11/locale"
    '';
}
