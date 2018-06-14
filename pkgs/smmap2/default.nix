{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonPackage fetchPypi;
in
  buildPythonPackage rec {
    pname = "smmap2";
    version = "2.0.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "c7530db63f15f09f8251094b22091298e82bf6c699a6b8344aaaef3f2e1276c3";
    };

    doCheck = false;

    meta = with stdenv.lib; {
      inherit (src.meta) homepage;
			description = "Git Object Database";
      license = licenses.bsd;
      platforms = platforms.all;
      maintainers = with maintainers; [ rummik ];
    };
  }



