{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name   = "muscle";
  version = "5.1.0";


  src = fetchFromGitHub {
    owner = "rcedgar";
    repo = "${name}";
    rev = "${version}";
    hash = "sha256-NpnJziZXga/T5OavUt3nQ5np8kJ9CFcSmwyg4m6IJsk=";
  };

  sourceRoot = "source/src";

  installPhase = ''
    install -m755 -D Linux/muscle $out/bin/muscle
  '';

  meta = with lib; {
    description = "Multiple sequence alignment with top benchmark scores scalable to thousands of sequences";
    license     = licenses.gpl3Plus;
    homepage    = "https://www.drive5.com/muscle/";
    maintainers = with maintainers; [ unode thyol ];
  };
}
