{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "gobuster";
  version = "v3.0.1";

  goPackagePath = "github.com/OJ/gobuster";
  goDeps = ./deps.nix;

  src = fetchgit {
    rev = version;
    url = "https://github.com/OJ/gobuster.git";
    sha256 = "0q8ighqykh8qyvidnm6az6dc9mp32bbmhkmkqzl1ybbw6paa8pym";
  };
}
