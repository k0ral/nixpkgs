{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  wrapGAppsHook3,
  dotnetCorePackages,
  fontconfig,
  gtk3,
  libunwind,
  openssl,
  xinput,
  xorg,
}:
buildDotnetModule rec {
  pname = "opentracker";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "trippsc2";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha512-nWkPgVYdnBJibyJRdLPe3O3RioDPbzumSritRejmr4CeiPb7aUTON7HjivcV/GKor1guEYu+TJ+QxYrqO/eppg==";
  };

  patches = [./remove-project.patch];

  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  nugetDeps = ./deps.nix;

  projectFile = "OpenTracker.sln";
  executables = ["OpenTracker"];

  doCheck = true;
  disabledTests = [
    "OpenTracker.UnitTests.Models.Nodes.Factories.SLightWorldConnectionFactoryTests.GetNodeConnections_ShouldReturnExpectedValue"
    "OpenTracker.UnitTests.Models.Sections.Factories.ItemSectionFactoryTests.GetItemSection_ShouldReturnExpected"
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    gtk3
    libunwind
  ];

  runtimeDeps =
    [
      gtk3
      openssl
      xinput
    ]
    ++ (with xorg; [
      libICE
      libSM
      libX11
      libXi
    ]);

  meta = with lib; {
    description = "Tracking application for A Link to the Past Randomizer";
    homepage = "https://github.com/trippsc2/OpenTracker";
    sourceProvenance = with sourceTypes; [
      fromSource
      # deps
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.mit;
    maintainers = [maintainers.ivar];
    mainProgram = "OpenTracker";
    platforms = ["x86_64-linux"];
  };
}
