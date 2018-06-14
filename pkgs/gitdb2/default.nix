{ stdenv, python3, callPackage }:

let
  inherit (python3.pkgs) buildPythonPackage fetchPypi;
  smmap2 = (callPackage ../smmap2/default.nix { });
in
  buildPythonPackage rec {
    pname = "gitdb2";
    version = "2.0.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "b60e29d4533e5e25bb50b7678bbc187c8f6bcff1344b4f293b2ba55c85795f09";
    };

    doCheck = false;

    propagatedBuildInputs = with python3.pkgs; [ smmap2 ];

    meta = with stdenv.lib; {
      inherit (src.meta) homepage;
			description = "Git Object Database";
      license = licenses.bsd;
      platforms = platforms.all;
      maintainers = with maintainers; [ rummik ];
    };
  }


