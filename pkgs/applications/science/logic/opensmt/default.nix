{ stdenv, lib, fetchFromGitHub
, cmake, libedit, gmpxx, bison, flex
, enableReadline ? false, readline
, gtest
}:

stdenv.mkDerivation rec {
  pname = "opensmt";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "usi-verification-and-security";
    repo = "opensmt";
    rev = "v${version}";
    sha256 = "sha256-v0CyVMi7Hb4Kdw8v/ZcKXpVHabq4m2cOhsNGXXVI4dw=";
  };

  nativeBuildInputs = [ cmake bison flex ];
  buildInputs = [ libedit gmpxx ]
    ++ lib.optional enableReadline readline;

  preConfigure = ''
    substituteInPlace test/CMakeLists.txt \
      --replace 'FetchContent_Populate' '#FetchContent_Populate'
  '';
  cmakeFlags = [
    "-Dgoogletest_SOURCE_DIR=${gtest.src}"
    "-Dgoogletest_BINARY_DIR=./gtest-build"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A satisfiability modulo theory (SMT) solver";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = if enableReadline then licenses.gpl2Plus else licenses.mit;
    homepage = "https://github.com/usi-verification-and-security/opensmt";
  };
}
