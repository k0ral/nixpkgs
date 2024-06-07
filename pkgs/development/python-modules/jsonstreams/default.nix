{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "jsonstreams";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dcbaker";
    repo = pname;
    rev = version;
    sha256 = "0qw74wz9ngz9wiv89vmilbifsbvgs457yn1bxnzhrh7g4vs2wcav";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests --doctest-modules jsonstreams" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "JSON streaming writer";
    homepage = "https://github.com/dcbaker/jsonstreams";
    license = licenses.mit;
    maintainers = with maintainers; [ chkno ];
  };
}
