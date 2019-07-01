{ stdenv, fetchgit, gcc, darwin, clang, ft }:

stdenv.mkDerivation rec {
  name = "tpkb-${version}";
  version = "1.1";

  src = fetchgit {
    url = "https://github.com/unknownzerx/tpkb";
    rev = "501074";
    sha256 = "1ljlzvz9p99gy7ydki55rg3y8gvkqszxn35f9878a46zr07nhhlb";
  };

  phases = [ "buildPhase" ];

  buildInputs = with darwin; with apple_sdk;
  (__attrValues libs) ++
  (__attrValues bareFrameworks) ++   [
    clang
  ];

  buildPhase = ''${ft.sh}
    cd $src/tpkb
    make
  '';

  meta = with stdenv.lib; {
    description     = "A next-generation plugin manager for zsh.";
    longDescription = "";
    homepage        = "https://github.com/zplug/zplug";
    license         = licenses.bsd;
    platforms       = platforms.darwin;
    maintainers     = with maintainers; [ rummik ];
  };
}
