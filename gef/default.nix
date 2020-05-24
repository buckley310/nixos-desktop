{ stdenv
, fetchFromGitHub
, makeWrapper
, gdb
}:
stdenv.mkDerivation rec {
  pname = "gef";
  version = "2020.03-1";

  src = fetchFromGitHub {
    owner = "hugsy";
    repo = "gef";
    rev = version;
    sha256 = "0b5w71cp6wfbnd29l60jl0ns3515g2zbsllbdk1yf41cbx4v2i0k";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gef
    cp gef.py $out/share/gef/
    find $out/share/gef/
    #xchmod +x $out/share/gef/gef.py
    makeWrapper ${gdb}/bin/gdb $out/bin/gef --add-flags "-q -x '$out/share/gef/gef.py'"
  '';
}
