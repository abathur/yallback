{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let
  yallback = callPackage ./default.nix { };
in
stdenv.mkDerivation {
  name = "yallback-ci";
  src = builtins.filterSource
    (path: type:
      type != "directory" || baseNameOf path
      == "tests") ./.;
  installPhase = ''
    mkdir $out
    # cp *demo.txt $out/
  '';
  doCheck = true;
  buildInputs = [ yara yallback ];

  checkPhase = ''
    echo rule dummy { condition: true } > my_first_rule
    echo 'yallback:rule:dummy:each(){ echo no, _you_ are the dummy! $@ ; }' > my_first_rodeo
    yara my_first_rule my_first_rule | yallback my_first_rodeo
  '';
}
