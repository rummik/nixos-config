{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  version = "2.4.1";
  name = "zplug-${version}";

  src = fetchgit {
    url = "https://github.com/zplug/zplug";
    rev = "${version}";
    sha256 = "034acnppfnfa9n72hzzlf83b0xgqp8f6070jr0pj6kkby6154p3q";
  };

  phases = "installPhase";

  installPhase = ''
    outdir=$out/share/zplug
  
    mkdir -p $outdir
    cp -r $src/* $outdir
    cd $outdir
  
    rm -rf .git*
  '';

  meta = with stdenv.lib; {
    description     = "A next-generation plugin manager for zsh.";
    longDescription = "";
    homepage        = "https://github.com/zplug/zplug";
    license         = licenses.mit;
    platforms       = platforms.all;
    maintainers     = with maintainers; [ rummik ];
  };
}
