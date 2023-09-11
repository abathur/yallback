{ stdenv
, bash
, yara
, yallback
, shellcheck
}:

{
  default = stdenv.mkDerivation {
    name = "yallback-ci";
    src = builtins.filterSource
      (path: type:
        type != "directory" || builtins.baseNameOf path
        == "tests") ./.;
    installPhase = ''
      mkdir $out
      # cp *demo.txt $out/
    '';
    doCheck = true;
    checkInputs = [ bash shellcheck yara yallback ];

    checkPhase = ''
      shellcheck ${yallback}/bin/yallback
      echo rule dummy { condition: true } > my_first_rule
      echo 'yallback:rule:dummy:each(){ echo no, _you_ are the dummy! $@ ; }' > my_first_rodeo
      yara my_first_rule my_first_rule | yallback my_first_rodeo
      ${bash}/bin/bash ./test.sh
    '';
  };
}
