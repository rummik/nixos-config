{ stdenv, lib, system, fetchFromGitHub
, pkgs, makeWrapper, buildEnv
, nodejs, libssh2, curl
}:

let

  inherit (stdenv.lib) attrValues makeSearchPath makeBinPath;

  nodePackages = import ./node.nix {
    inherit pkgs nodejs system;
  };

in
  
stdenv.mkDerivation rec {
  pname = "git-meta";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "twosigma";
    repo = "git-meta";
    rev = "1964ea4ae70b73110a837aa4979f828ddaf752b3";
    sha256 = "0zysbdjgnpj8cq4m12m627gnzcj9400czj7zv5sajp8d5y4wahq7";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs ];

  NODE_PATH = makeSearchPath "lib/node_modules" (
    attrValues (nodePackages // {
      "nodegit-^0.23.0" =
        nodePackages."nodegit-^0.23.0".override {
          buildInputs = [
            curl
            libssh2
            nodejs
          ];
        };
    })
  );

  installPhase = /* sh */ ''
    mkdir -p $out/{bin,share}

    cp -r node $out/share/git-meta

    for file in $out/share/git-meta/bin/*; do
      makeWrapper $file $out/bin/''${file##*/} \
        --set NODE_PATH $NODE_PATH
    done
  '';

  meta = with stdenv.lib; {
    description = "Build your own monorepo using Git submodules";
    license = licenses.bsd3;
    homepage = https://github.com/twosigma/git-meta;
    maintainers = with maintainers; [ rummik ];
    platforms = platforms.linux;
  };
}
