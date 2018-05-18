{ stdenv, fetchFromGitHub, pkgs, pkgsi686Linux,
  extraLDPathPkgs ? [],
  extraLDFlagsPkgs ? [],
  extraCPPFlagsPkgs ? [],
  extraPathPkgs ? [],
  extraPkgConfigPkgs ? []
}:

let
  inherit (stdenv.lib) makeSearchPathOutput concatMapStrings makeLibraryPath
    makeBinPath splitString chooseDevOutputs;

  makePathFlags = flag: path:
    concatMapStrings (x: flag + x + " ") (splitString ":" path);

  makeIncludePath = drvs:
    makeSearchPathOutput "include" "include" (chooseDevOutputs drvs);

  makePkgConfigPath = drvs:
    makeSearchPathOutput "lib/pkgconfig" "lib/pkgconfig" (chooseDevOutputs drvs);

  mkMultiarch = fn: (fn pkgsi686Linux) ++ (fn pkgs);

  makeLibraryFlags = pkgsIn: makePathFlags "-L" (makeLibraryPath pkgsIn);

  makeIncludeFlags = pkgsIn: makePathFlags "-I" (makeIncludePath pkgsIn);
in
  stdenv.mkDerivation rec {
    version = "0.33.6";
    name = "nvm-${version}";

    src = fetchFromGitHub {
      owner = "creationix";
      repo = "nvm";
      rev = "v${version}";
      sha256 = "0q6ikpk98a7y6jkj7zvi1nc2drp93lnfqq0p0974y5hz8yh9s9mf";
    };

    phases = "installPhase";

    ldLibraryPathPkgs = extraLDPathPkgs ++ mkMultiarch (ps: with ps; [
      glibc
      gcc6
      gcc-unwrapped

      gtk2-x11
      atk
      glib
      pango
      gdk_pixbuf
      cairo
      freetype
      fontconfig
      dbus
      xorg.libXi
      xorg.libX11
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libXext
      xorg.libXfixes
      xorg.libXrender
      xorg.libXtst
      xorg.libXScrnSaver
      xorg.libxcb
      gnome2.GConf
      nss
      nspr
      alsaLib
      cups
      expat
      zlib
    ]);

    ldFlagsPkgs = extraLDFlagsPkgs ++ mkMultiarch (ps: with ps; [
      glibc
    ]);

    cppFlagsPkgs = extraCPPFlagsPkgs ++ mkMultiarch (ps: with ps; [
      glibc
    ]);

    pathPkgs = extraPathPkgs ++ mkMultiarch (ps: with ps; [
      gcc6
      gnumake
      python
      binutils-unwrapped
    ]);

    pkgConfigPkgs = extraPkgConfigPkgs;

    installPhase = ''
      outdir=$out/share/nvm
    
      mkdir -p $outdir
      cp -r $src/* $outdir
      cd $outdir
    
      rm -rf .git* nvm.sh

      cat > env.sh <<- "EOT"
        NVM_LD_LIBRARY_PATH="${makeLibraryPath ldLibraryPathPkgs}"
        NVM_LDFLAGS="${makeLibraryFlags ldFlagsPkgs}"
        NVM_CPPFLAGS="${makeIncludeFlags cppFlagsPkgs}"
        NVM_PATH="${makeBinPath pathPkgs}"
        NVM_PKG_CONFIG_PATH="${makePkgConfigPath pkgConfigPkgs}"
      EOT

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
