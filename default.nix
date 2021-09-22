{ pkgs ? import <nixpkgs> { }, doCheck ? true }:

with pkgs;
stdenv.mkDerivation rec {
  version = "0.1.0";
  pname = "yallback";
  src = lib.cleanSource ./.;

  buildInputs = [ coreutils bashInteractive ];
  nativeBuildInputs = [ makeWrapper ];

  inherit doCheck;
  checkInputs = [ shellcheck ];
  checkPhase = ''
    ${shellcheck}/bin/shellcheck yallback
  '';

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
