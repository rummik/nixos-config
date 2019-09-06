{
  fetchFromGitHub,
  buildVimPluginFrom2Nix,
}:

{
  vader = (buildVimPluginFrom2Nix {
    pname = "vader";
    version = "ddb71424";

    src = fetchFromGitHub {
      owner = "junegunn";
      repo = "vader.vim";
      rev = "ddb714246535e814ddd7c62b86ca07ffbec8a0af";
      sha256 = "0jlxbp883y84nal5p55fxg7a3wqh3zny9dhsvfjajrzvazmiz44n";
    };
  });

  vim-nix = (buildVimPluginFrom2Nix {
    pname = "vim-nix";
    version = "2019-09-02";

    src = fetchFromGitHub {
      owner = "rummik";
      repo = "vim-nix";
      rev = "7cad7f3666a63ff00f7ecd73a98886031901b918";
      sha256 = "14srhdci02qv25v4s2h0wqd40vh127gcxwjzliqa9dq3pngw96gx";
    };
  });

  vim-smali = (buildVimPluginFrom2Nix {
    pname = "vim-smali";
    version = "2017-03-07";

    src = fetchFromGitHub {
      owner = "rummik";
      repo = "vim-smali";
      rev = "46d2a7583234bf0819a18d9f73ab8c751d6a58ad";
      sha256 = "1br3jir8v2hzrhmj2fdsd74gi65ikrwipimjfkwscd6z9c32s50d";
    };
  });

  vim-workspace = (buildVimPluginFrom2Nix {
    pname = "vim-workspace";
    version = "2018-12-11";

    src = fetchFromGitHub {
      owner = "thaerkh";
      repo = "vim-workspace";
      rev = "e48ca349c6dd0c9ea8261b7d626198907550306b";
      sha256 = "1sknd5hg710lqvqnk8ymvjnfw65lgx5f8xz88wbf7fhl31r9sa89";
    };
  });

  yajs = (buildVimPluginFrom2Nix {
    pname = "yajs.vim";
    version = "2019-02-01";

    src = fetchFromGitHub {
      owner = "othree";
      repo = "yajs.vim";
      rev = "437be4ccf0e78fe54cb482657091cff9e8479488";
      sha256 = "157q2w2bq1p6g1wc67zl53n6iw4l04qz2sqa5j6mgqg71rgqzk0p";
    };
  });
}
