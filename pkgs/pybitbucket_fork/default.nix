{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonPackage fetchPypi;
in
  buildPythonPackage rec {
    pname = "pybitbucket_fork";
    version = "0.12.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "6b1571b8386791039f38849fa96880ec6ff91ad5d47133cb93b36ee092e49431";
    };

    doCheck = false;

    propagatedBuildInputs = with python3.pkgs; [ simplejson future six uritemplate requests_oauthlib voluptuous ];

    meta = with stdenv.lib; {
      inherit (src.meta) homepage;
      description = "Fork of a Python wrapper for the Bitbucket API";
      license = licenses.apache2;
      platforms = platforms.all;
      maintainers = with maintainers; [ rummik ];
    };
  }

