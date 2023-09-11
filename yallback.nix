{ lib
, stdenv
, fetchFromGitHub
, version ? "0.2.0"
, src ? fetchFromGitHub {
    owner = "abathur";
    repo = "yallback";
    rev = "v${version}";
    hash = "sha256-t+fdnDJMFiFqN23dSY3TnsZsIDcravtwdNKJ5MiZosE=";
  }
, makeWrapper
, coreutils
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "yallback";
  inherit version src;

  buildInputs = [ coreutils bashInteractive ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dv yallback $out/bin/yallback
    wrapProgram $out/bin/yallback --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  meta = with lib; {
    description = "Callbacks for YARA rule matches";
    homepage = "https://github.com/abathur/yallback";
    license = licenses.mit;
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
