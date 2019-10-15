{ lib, fetchFromGitHub, fetchFromGitLab }:

let

  inherit (lib) isString replaceStrings optionalAttrs optionalString;

  mkZshPlugin = { name, src, file ? null }@args:
    {
      inherit src;
      name = replaceStrings [ "/" ] [ "-" ] name;
    }
    // optionalAttrs (isString file) { inherit file; };

  zshPluginFromGitHub =
    { owner, repo, rev, sha256, name ? repo, file ? null }:

    mkZshPlugin {
      inherit name file;
      src = fetchFromGitHub { inherit owner repo rev sha256; };
    };

  zshPluginFromGitLab =
    { owner, repo, rev, sha256, name ? repo, file ? null }:

    mkZshPlugin {
      inherit name file;

      src = fetchFromGitLab {
        inherit owner rev sha256;
        repo = replaceStrings ["/"] ["%2F"] repo;
      };
    };

in

{
  theme = {
    rummik = zshPluginFromGitLab {
      owner = "rummik";
      repo = "zsh/theme";
      file = "rummik.zsh-theme";
      rev = "a65c97c8b99d778a1fa0dcb0e96a91ec67b7d1cd";
      sha256 = "0jkr30mabha5wf92i5nmrdr4pbv985lm06sw2qqq7b6qj7qdi2y3";
    };
  };

  nix-shell = zshPluginFromGitHub {
    name = "nix-shell";
    owner = "chisui";
    repo = "zsh-nix-shell";
    rev = "b2609ca787803f523a18bb9f53277d0121e30389";
    sha256 = "01w59zzdj12p4ag9yla9ycxx58pg3rah2hnnf3sw4yk95w3hlzi6";
  };

  wakatime = zshPluginFromGitHub {
    owner = "wbingli";
    repo = "zsh-wakatime";
    rev = "6b882ba5bf743759afe29676e4e707a6d8db1078";
    sha256 = "0hdav1z30822k0dp67n5kfd4z9x098m0d6p7jjmgl2spwnj74hx0";
  };

  autosuggestions = zshPluginFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "3da421aa47fdcb10bf3d19f1c35946b03c1bd90e";
    sha256 = "05kxx1dik9xl5pqbn6sknswqc1hvq1q7116irdd0x8f8zw89b53r";
  };

  completions = zshPluginFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "b512d57b6d0d2b85368a8068ec1a13288a93d267";
    sha256 = "027wv0phw1pb5jdj7s7skbwd4ix7i9d2p7n2q65hzf36ha2jjvql";
  };

  syntax-highlighting = zshPluginFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = "7ac72a57bc7e5cc0ad84ef005d75c39d101b32a0";
    sha256 = "083rzgna6rc5pdhbf83kan7ck2c26gs73n0s5cqhfnmi2vskzqky";
  };

  dug = zshPluginFromGitLab {
    name = "dug";
    owner = "rummik";
    repo = "zsh/dug";
    rev = "86fdc610da39f65d2ce24f4a4879f754e2035bd4";
    sha256 = "0b6q0yydd96qr5cbr4sykl58j9sab12dh80k6xhdvlijqbil44hb";
  };

  ing = zshPluginFromGitLab {
    name = "ing";
    owner = "rummik";
    repo = "zsh/ing";
    rev = "166f130c02444065ff489a85ed08bc00fd2bd70f";
    sha256 = "0g6lz4hzqnjdxfxqiwp02cidypifr1jgwwnk0hyadac6s2jcdkms";
  };

  isup = zshPluginFromGitLab {
    name = "isup";
    owner = "rummik";
    repo = "zsh/isup";
    rev = "0ce5d81c2c29955d39c28b48627d5f2ea209611c";
    sha256 = "1zjlxff82c52s4hnmnz0xhkvywp3m758zzyy43b60chzcppdpvnx";
  };

  please = zshPluginFromGitLab {
    name = "please";
    owner = "rummik";
    repo = "zsh/please";
    rev = "5706e7b7eb1d1c6b3dbdbe9402392e84b297568e";
    sha256 = "1bn2lvccmagqzjx9c3w7hh6cl32fm8gczhpikaq35lc40ijywi6y";
  };

  psmin = zshPluginFromGitLab {
    name = "psmin";
    owner = "rummik";
    repo = "zsh/psmin";
    rev = "3120062717d0a82fe33ee9bf9b4eabca8323f322";
    sha256 = "0sz81q9sc0c8j19qb83n31q28ag5jnigawb7i04023vmxm1ljx88";
  };

  psmin-gitflow = zshPluginFromGitLab {
    name = "psmin-gitflow";
    owner = "rummik";
    repo = "zsh/psmin-gitflow";
    rev = "4afdf2639891b16b7250fd1065cd0a3ddccea484";
    sha256 = "0pvrbiw12n0wrzkynyr48vfn0qmis5rxwkqxfi4k2xxbbimjxwn3";
  };

  slowcat = zshPluginFromGitLab {
    name = "slowcat";
    owner = "rummik";
    repo = "zsh/slowcat";
    rev = "f089130d881cef04f46a13322c7998d5aaa4201b";
    sha256 = "0zrzyn16mjxfkd5ln741sn6frqkms47cap3y1ndxs6v06jpy2pr2";
  };

  tailf = zshPluginFromGitLab {
    name = "tailf";
    owner = "rummik";
    repo = "zsh/tailf";
    rev = "92b04527b784a70a952efde20e6a7269278fb17d";
    sha256 = "0z07zj5d2j0lci72ykl471bav3bz2f5ps8sdsdh00c60a8ar6n94";
  };
}
