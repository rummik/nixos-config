{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonPackage fetchPypi;
in
  buildPythonPackage rec {
    pname = "python-gitlab";
    version = "1.4.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "34a5eb1704e68a23bafb9b122c456ff72b3e1a2d3bdcd44346bbde6a5d7af511";
    };

    doCheck = false;

    propagatedBuildInputs = with python3.pkgs; [ simplejson six requests ];

    meta = with stdenv.lib; {
      inherit (src.meta) homepage;
      description = "Interact with GitLab API";
      license = licenses.lgpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [ rummik ];
    };
  }

