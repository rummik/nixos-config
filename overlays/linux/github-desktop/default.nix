{ stdenv, fetchurl, autoPatchelfHook
, atomEnv
, cups
, curl
, dpkg
, openssl
, udev
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "github-desktop";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/shiftkey/desktop/releases/download/release-${version}-linux1/GitHubDesktop-linux-${version}-linux1.deb";
    sha256 = "0xq0wkzq00mz9g2gvwjjvs2001kgvh193d5rq52s416zlizczm4d";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    atomEnv.packages
    cups
    curl
    openssl
  ];

  runtimeDependencies = [
    udev.lib
  ];

  unpackPhase = /* sh */ ''
    dpkg -x $src .
  '';

  installPhase = /* sh */ ''
    mkdir -p $out/{bin,opt}
    cp -ar ./usr $out
    cp -ar ./opt/GitHub\ Desktop $out/opt/github-desktop
    ln -s $out/opt/github-desktop/github-desktop $out/bin/github-desktop
  '';

  postFixup = /* sh */ ''
    substituteInPlace $out/usr/share/applications/github-desktop.desktop \
      --replace /opt/GitHub\ Desktop $out/opt/github-desktop
  '';

  meta = with stdenv.lib; {
    description = "Simple collaboration from your desktop";
    longDescription = ''
      Fork of GitHub Desktop to support various Linux distributions
      GitHub Desktop is an open source Electron-based GitHub app. It is written in TypeScript and uses React.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ rummik ];
    homepage = https://github.com/shiftkey/desktop;
    platforms = [ "x86_64-linux" ];
  };
}
