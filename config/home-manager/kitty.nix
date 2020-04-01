let

  inherit (import ../../channels) __nixPath;

  nur = import ../../nix/nur.nix;

in

{
  disabledModules = [ <home-manager/modules/programs/kitty.nix> ];

  imports = [
    nur.repos.rummik.home-manager.modules.kitty
  ];

  programs.kitty = {
    enable = true;

    fonts = rec {
      fontFamily = "Fira Code Regular";
      boldFont = fontFamily;
      italicFont = fontFamily;
      boldItalicFont = fontFamily;

      fontSize = 9.0;
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
				"2"  = "#4e9a06";
				"10" = "#8ae234";

				#: yellow
				"3"  = "#c4a000";
				"11" = "#fce94f";

				#: blue
				"4"  = "#3465a4";
				"12" = "#729fcf";

				#: magenta
				"5"  = "#75507b";
				"13" = "#ad7fa8";

				#: cyan
				"6"  = "#06989a";
				"14" = "#34e2e2";

				#: white
				"7"  = "#d3d7cf";
				"15" = "#eeeeec";
			};
    };

    extraConfig = {
      scrollbackLines = 0;
      mouseHideWait = -1;
      windowPaddingWidth = 1.0;
    };
  };
}
