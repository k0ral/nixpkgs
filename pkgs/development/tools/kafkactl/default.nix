{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kafkactl";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rz3cAA5iqhrCZhLc+RKZhudiMlfu3m6wWYNHAnUP/kg=";
  };

  vendorHash = "sha256-Y3BPt3PsedrlCoKiKUObf6UQd+MuNiCGLpJUg94XSgA=";
  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Command Line Tool for managing Apache Kafka";
    longDescription = ''
      A command-line interface for interaction with Apache Kafka.
      Features:
      - command auto-completion for bash, zsh, fish shell including dynamic completion for e.g. topics or consumer groups
      - support for avro schemas
      - Configuration of different contexts
      - directly access kafka clusters inside your kubernetes cluster
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ grburst ];
    platforms = platforms.unix;
  };
}
