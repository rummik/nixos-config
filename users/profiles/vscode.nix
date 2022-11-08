{
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    # Not available on x86_32
    enable = lib.mkIf (!pkgs.stdenv.isx86_32) true;
    #enableUpdateCheck = false;
  };
}
