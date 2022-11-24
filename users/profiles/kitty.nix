{
  pkgs,
  inputs,
  modulesPath,
  ...
}: {
  disabledModules = [
    "${modulesPath}/programs/kitty.nix"
  ];

  imports = [
    ../modules/kitty.nix
  ];

  programs.kitty = {
    enable = true;

    fonts = rec {
      fontFamily = "Fira Code Regular Nerd Font Complete";
      boldFont = fontFamily;
      italicFont = fontFamily;
      boldItalicFont = fontFamily;
      fontFeatures = let
        firaCodeFeatures = [
          # "-liga" # disable ligatures
          # "calt" # enable (some) ligatures
          "ss01" # r
          "ss02" # ss02, cv19..23: <= >=
          "ss03" # &
          "ss04" # $
          # "ss05" # @
          "ss06" # \\
          "ss07" # =~ !~
          # "ss08" # == === != !==
          "ss09" # >>= <<= ||= |=
          # "ss10" # Fl Tl fi fj fl ft
          # "cv01" # a
          "cv02" # g
          # "cv03" # cv03..06: i
          # "cv07" # cv07..10: l
          "cv13" # zero, cv11..13: 0
          "cv14" # 3
          # "cv15" # cv15..16: *
          # "cv17" # ~
          # "cv18" # %
          # "cv19" # ss02, cv19..20: <=
          # "cv22" # ss02, cv21..22: >=
          # "cv23" # ss02, cv23: >=
          # "cv24" # /=
          "cv25" # .-
          "cv26" # :-
          "cv27" # []
          "cv28" # {. .}
          # "cv29" # {}
          # "cv30" # |
          # "cv31" # ()
          "cv32" # .=
        ];
      in {
        FiraCodeNerdFontComplete-Bold = firaCodeFeatures;
        FiraCodeNerdFontComplete-Light = firaCodeFeatures;
        FiraCodeNerdFontComplete-Medium = firaCodeFeatures;
        FiraCodeNerdFontComplete-Regular = firaCodeFeatures;
        FiraCodeNerdFontComplete-Retina = firaCodeFeatures;
        FiraCodeNerdFontComplete-SemiBold = firaCodeFeatures;
      };

      fontSize = 72.0 / 96.0 * 12.0; # ~12px
      #fontSize = 5.204819277108434; # 12px on a 166ppi display
    };

    cursor.blinkInterval = 0;

    colorScheme = {
      foreground = "#ffffff";
      background = "#000000";
      backgroundOpacity = 0.94;
      selectionBackground = "#555753";

      color = {
        #: black
        "0" = "#2e3436";
        "8" = "#555753";

        #: red
        "1" = "#cc0000";
        "9" = "#ef2929";

        #: green
        "2" = "#4e9a06";
        "10" = "#8ae234";

        #: yellow
        "3" = "#c4a000";
        "11" = "#fce94f";

        #: blue
        "4" = "#3465a4";
        "12" = "#729fcf";

        #: magenta
        "5" = "#75507b";
        "13" = "#ad7fa8";

        #: cyan
        "6" = "#06989a";
        "14" = "#34e2e2";

        #: white
        "7" = "#d3d7cf";
        "15" = "#eeeeec";
      };
    };

    maps."ctrl+shift+p>f" = "no_op";
    maps."ctrl+shift+p>n" = "no_op";
    maps."ctrl+shift+p>y" = "no_op";
    maps."ctrl+shift+p" = "no_op";
    maps."ctrl+shift+k" = "no_op";

    extraConfig = {
      scrollbackLines = 0;
      mouseHideWait = -1;
      windowPaddingWidth = 1.0;
    };
  };
}
