with import <nixpkgs> {};

stdenv.mkDerivation rec {
  version = "0.33.6";
  name = "nvm-${version}";

  src = fetchgit {
    url = "https://github.com/creationix/nvm";
    rev = "v${version}";
    sha256 = "0q6ikpk98a7y6jkj7zvi1nc2drp93lnfqq0p0974y5hz8yh9s9mf";
  };

  phases = "installPhase";

  installPhase = ''
    outdir=$out/share/nvm
  
    mkdir -p $outdir
    cp -r $src/* $outdir
    cd $outdir
  
    rm -rf .git* nvm.sh

    cat $src/nvm.sh - > nvm.sh <<- "EOT"
      nvm_nixos_install_hook() {
        local nobinary=''${NVM_SOURCE_INSTALL:-1}
  
        # skip binary install if "nobinary" option specified.
        if [ $nobinary -ne 1 ] && nvm_binary_available "$VERSION"; then
          nvm_install_binary "$FLAVOR" std "$VERSION"
          EXIT_CODE=$?
        fi
  
        if [ "$EXIT_CODE" -ne 0 ]; then
          if [ -z "''${NVM_MAKE_JOBS-}" ]; then
            nvm_get_make_jobs
          fi
  
          nvm_install_source "$FLAVOR" std "$VERSION" "$NVM_MAKE_JOBS" "$ADDITIONAL_PARAMETERS"
          EXIT_CODE=$?
        fi
      }

      NVM_INSTALL_THIRD_PARTY_HOOK=nvm_nixos_install_hook

      NVM_DIR=$HOME/.nvm
    EOT
  '';

  meta = with stdenv.lib; {
    description     = "Node Version Manager - Simple bash script to manage multiple active node.js versions";
    longDescription = "";
    homepage        = "https://github.com/creationix/nvm";
    license         = licenses.mit;
    platforms       = platforms.all;
    maintainers     = with maintainers; [ rummik ];
  };
}
