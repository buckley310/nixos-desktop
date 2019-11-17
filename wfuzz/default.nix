{ stdenv, pkgs, python3Packages }:
python3Packages.buildPythonPackage rec {
    pname = "wfuzz";
    version = "2.4";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0sqvgy4ayvxw9zv81fn2w470akwhyyfnlzjbxk732a6bh37c0ib8";
    };

    propagatedBuildInputs = with python3Packages; [ chardet configparser future pycurl pyparsing six ];

    meta = with stdenv.lib; {
      homepage = http://www.edge-security.com/wfuzz.php;
      description = "The web application Bruteforcer";
    };
}
