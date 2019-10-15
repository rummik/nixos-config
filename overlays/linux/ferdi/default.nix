{
  stdenv,
  lib,
  franz,
  fetchurl,
}:

let

  sbubby = string:
    lib.replaceStrings
      [ "franz" "Franz" ]
      [ "ferdi" "Ferdi" ]
      string;

in

franz.overrideAttrs (franz: rec {
  pname = "ferdi";
  version = "5.3.4-beta.6";

  src = fetchurl {
    url = "https://github.com/getferdi/ferdi/releases/download/v${version}/ferdi_${version}_amd64.deb";
    sha256 = "0mavlbzpc5z139j3vy0ywq8j1kvvbsmkn2gjvh1hz7k5rd5a4mlc";
  };

  installPhase = sbubby franz.installPhase;
  postFixup = sbubby franz.postFixup;

  meta = franz.meta // {
    homepage = https://getferdi.org;
  };
})
