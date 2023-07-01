{
  programs.nixvim.plugins.nvim-colorizer = {
    enable = true;

    fileTypes =
      let
        css = { css = true; };
      in
      [
        "*"
        ({ language = "css"; } // css)
        ({ language = "scss"; } // css)
        ({ language = "sass"; } // css)
        ({ language = "less"; } // css)
        ({ language = "stylus"; } // css)
      ];

    bufTypes = [
      "*"
      "!prompt"
      "!popup"
    ];

    userDefaultOptions = {
      RGB = false;
      names = false;
      RRGGBBAA = true;
      AARRGGBB = true;
    };
  };
}
